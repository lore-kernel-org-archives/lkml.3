Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3G2WlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:41:03 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53942 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab3G2WlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:41:01 -0400
Message-ID: <51F6EF7A.4000209@gmail.com>
Date: Mon, 29 Jul 2013 16:40:58 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>, acme@ghostprotocols.net
CC: a.p.zijlstra@chello.nl, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Do not require /lib/modules/* on a guest
References: <1373920073-4874-1-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1373920073-4874-1-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/15/13 2:27 PM, Jason Wessel wrote:
> For some types of work loads and special guest environments, you might
> have a kernel that has no kernel modules.  The perf kvm record tool
> fails instantiate vmlinux maps when the kernel modules directory
> cannot be opened, even though the kallsyms has been properly
> processed.  This leads to a perf kvm report that has no guest symbols
> resolved.

Theoretically, use of modules is an option:

     if (symbol_conf.use_modules && machine__create_modules(machine) < 0) {
...
     }

But, the use_modules option was flipped from false to true by b32d133a 
back in 2009. And the lack of complaints suggests this ominous warning 
in perf-report, diff and annotate is moot:

     OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
             "load module symbols - WARNING: use only with -k and LIVE 
kernel"),

>
> This patch changes the failure to locate kernel modules to be
> non-fatal.
>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>   tools/perf/util/machine.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index b2ecad6..eb9ebd6 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -808,7 +808,10 @@ static int machine__create_modules(struct machine *machine)
>   	free(line);
>   	fclose(file);
>
> -	return machine__set_modules_path(machine);
> +	if (machine__set_modules_path(machine) < 0) {
> +		pr_debug("Problems setting modules path maps, continuing anyway...\n");
> +	}
> +	return 0;
>
>   out_delete_line:
>   	free(line);

Acked-by: David Ahern <dsahern@gmail.com>

