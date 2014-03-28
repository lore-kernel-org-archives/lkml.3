Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaC1Syh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:54:37 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46724 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbaC1Syc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:54:32 -0400
Date: Fri, 28 Mar 2014 11:54:43 -0700
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, christoffer.dall@linaro.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        rob.herring@linaro.org
Subject: Re: [RFC 5/5] tty: Update hypervisor tty drivers to use core stdout
 parsing code.
Message-ID: <20140328185443.GA26433@quad.lixom.net>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
 <1396022885-6102-6-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396022885-6102-6-git-send-email-grant.likely@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 28, 2014 at 09:08:05AM -0700, Grant Likely wrote:
> The evh_bytechan, hvc_opal and hvc_vio drivers all open code the parsing
> of the stdout node in the device tree. This patch simplifies the driver
> by removing the duplicated functionality.
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/of/base.c          |  5 ++++-
>  drivers/tty/ehv_bytechan.c | 43 ++++---------------------------------------
>  drivers/tty/hvc/hvc_opal.c | 14 +++-----------
>  drivers/tty/hvc/hvc_vio.c  | 29 ++++++++++-------------------
>  include/linux/of.h         |  1 +
>  5 files changed, 22 insertions(+), 70 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index a5643badeb1d..f845fd05d750 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -35,7 +35,7 @@ struct device_node *of_allnodes;
>  EXPORT_SYMBOL(of_allnodes);
>  struct device_node *of_chosen;
>  struct device_node *of_aliases;
> -static struct device_node *of_stdout;
> +struct device_node *of_stdout;
>  
>  static struct kset *of_kset;
>  
> @@ -1956,9 +1956,12 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
>  		of_chosen = of_find_node_by_path("/chosen@0");
>  
>  	if (of_chosen) {
> +		/* linux,stdout-path and /aliases/stdout are for legacy compatibility */
>  		const char *name = of_get_property(of_chosen, "stdout-path", NULL);
>  		if (!name)
>  			name = of_get_property(of_chosen, "linux,stdout-path", NULL);
> +		if (!name)
> +			name = of_get_property(of_aliases, "stdout", NULL);
>  		if (name)
>  			of_stdout = of_find_node_by_path(name);
>  	}
> diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
> index 0419b69e270f..4f485e88f60c 100644
> --- a/drivers/tty/ehv_bytechan.c
> +++ b/drivers/tty/ehv_bytechan.c
> @@ -108,55 +108,23 @@ static void disable_tx_interrupt(struct ehv_bc_data *bc)
>   *
>   * The byte channel to be used for the console is specified via a "stdout"
>   * property in the /chosen node.
> - *
> - * For compatible with legacy device trees, we also look for a "stdout" alias.
>   */

Did you mean to remove this /aliases/stdout checking? Based on the comment it
seems that some older device trees / platforms might rely on it?

>  static int find_console_handle(void)
>  {
> -	struct device_node *np, *np2;
> +	struct device_node *np = of_stdout;
>  	const char *sprop = NULL;
>  	const uint32_t *iprop;
>  
> -	np = of_find_node_by_path("/chosen");
> -	if (np)
> -		sprop = of_get_property(np, "stdout-path", NULL);
> -
> -	if (!np || !sprop) {
> -		of_node_put(np);
> -		np = of_find_node_by_name(NULL, "aliases");
> -		if (np)
> -			sprop = of_get_property(np, "stdout", NULL);
> -	}
> -
> -	if (!sprop) {
> -		of_node_put(np);
> -		return 0;
> -	}
> -
>  	/* We don't care what the aliased node is actually called.  We only
>  	 * care if it's compatible with "epapr,hv-byte-channel", because that
> -	 * indicates that it's a byte channel node.  We use a temporary
> -	 * variable, 'np2', because we can't release 'np' until we're done with
> -	 * 'sprop'.
> +	 * indicates that it's a byte channel node.
>  	 */
> -	np2 = of_find_node_by_path(sprop);
> -	of_node_put(np);
> -	np = np2;
> -	if (!np) {
> -		pr_warning("ehv-bc: stdout node '%s' does not exist\n", sprop);
> -		return 0;
> -	}
> -
> -	/* Is it a byte channel? */
> -	if (!of_device_is_compatible(np, "epapr,hv-byte-channel")) {
> -		of_node_put(np);
> +	if (!np || !of_device_is_compatible(np, "epapr,hv-byte-channel"))
>  		return 0;
> -	}
>  
>  	stdout_irq = irq_of_parse_and_map(np, 0);
>  	if (stdout_irq == NO_IRQ) {
> -		pr_err("ehv-bc: no 'interrupts' property in %s node\n", sprop);
> -		of_node_put(np);
> +		pr_err("ehv-bc: no 'interrupts' property in %s node\n", np->full_name);
>  		return 0;
>  	}
>  
> @@ -167,12 +135,9 @@ static int find_console_handle(void)
>  	if (!iprop) {
>  		pr_err("ehv-bc: no 'hv-handle' property in %s node\n",
>  		       np->name);
> -		of_node_put(np);
>  		return 0;
>  	}
>  	stdout_bc = be32_to_cpu(*iprop);
> -
> -	of_node_put(np);
>  	return 1;
>  }
>  
> diff --git a/drivers/tty/hvc/hvc_opal.c b/drivers/tty/hvc/hvc_opal.c
> index b01659bd4f7c..0ec1a80dd6a2 100644
> --- a/drivers/tty/hvc/hvc_opal.c
> +++ b/drivers/tty/hvc/hvc_opal.c
> @@ -322,22 +322,14 @@ static void udbg_init_opal_common(void)
>  
>  void __init hvc_opal_init_early(void)
>  {
> -	struct device_node *stdout_node = NULL;
> +	struct device_node *stdout_node = of_node_get(of_stdout);
>  	const __be32 *termno;
>  	const char *name = NULL;

Name is no longer used, should be removed.

>  	const struct hv_ops *ops;
>  	u32 index;
>  
> -	/* find the boot console from /chosen/stdout */
> -	if (of_chosen)
> -		name = of_get_property(of_chosen, "linux,stdout-path", NULL);
> -	if (name) {
> -		stdout_node = of_find_node_by_path(name);
> -		if (!stdout_node) {
> -			pr_err("hvc_opal: Failed to locate default console!\n");
> -			return;
> -		}
> -	} else {
> +	/* If the console wasn't in /chosen, try /ibm,opal */
> +	if (!stdout_node) {
>  		struct device_node *opal, *np;
>  
>  		/* Current OPAL takeover doesn't provide the stdout


-Olof
