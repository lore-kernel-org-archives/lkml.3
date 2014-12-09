Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaLISd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:33:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaLISd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:33:26 -0500
Date: Tue, 9 Dec 2014 12:32:49 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] livepatch v5: avoid race when checking for state of
 the patch
Message-ID: <20141209183249.GA25239@treble.redhat.com>
References: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
 <1418148307-21434-2-git-send-email-pmladek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1418148307-21434-2-git-send-email-pmladek@suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 07:05:02PM +0100, Petr Mladek wrote:
> klp_patch_enable() and klp_patch_disable() should check the current state
> of the patch under the klp_lock. Otherwise, it might detect that the operation
> is valid but the situation might change before it takes the lock.

Hi Petr,

Thanks for the patches.

I don't think this patch is necessary.  klp_is_enabled() doesn't check
the state of the patch.  It checks the initialization state of the core
module (klp_root_kobj), which can only be set in klp_init().  It's not
protected by the lock, so I don't see the point of this patch.

> 
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---
>  kernel/livepatch/core.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index d6d0f50e81f8..b848069e44cc 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -425,11 +425,13 @@ int klp_disable_patch(struct klp_patch *patch)
>  {
>  	int ret;
>  
> -	if (!klp_is_enabled())
> -		return -ENODEV;
> -
>  	mutex_lock(&klp_mutex);
>  
> +	if (!klp_is_enabled()) {
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +
>  	if (!klp_patch_is_registered(patch)) {
>  		ret = -EINVAL;
>  		goto err;
> @@ -489,11 +491,13 @@ int klp_enable_patch(struct klp_patch *patch)
>  {
>  	int ret;
>  
> -	if (!klp_is_enabled())
> -		return -ENODEV;
> -
>  	mutex_lock(&klp_mutex);
>  
> +	if (!klp_is_enabled()) {
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +
>  	if (!klp_patch_is_registered(patch)) {
>  		ret = -EINVAL;
>  		goto err;
> -- 
> 1.8.5.2
> 

-- 
Josh
