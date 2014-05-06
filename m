Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbaEFRcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:32:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaEFRcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:32:00 -0400
Date: Tue, 6 May 2014 19:31:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        tkhai@yandex.ru
Subject: Re: [PATCH] kmod: Pass usermodehelper "-b" to use blacklist
	commands
Message-ID: <20140506173136.GA1535@redhat.com>
References: <1399363388.3718.59.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399363388.3718.59.camel@tkhai>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06, Kirill Tkhai wrote:
>
> User may want to prohibit autoloading of some modules,
> which happens when someone in kernel calls request_module().
>
> For comparison, udev considers blacklist even if corresponding
> hardware presents in the system. In-kernel request_module()
> functionality is rather similar to udev's, so user may want
> to disallow it too.

Personally, I am always nervous (perhaps too much) when it comes to the
user-visible changes like this.

And if a user/distro wants "-b" it can create a simple script which just
execs /sbin/modprobe with "-b" and overwrite /proc/sys/kernel/modprobe.

OTOH. What if /proc/sys/kernel/modprobe points to a binary which is not
/sbin/modprobe and doesn't expect "-b" ? This can break things.

I am not really arguing, but someone should ack this change ;)


As for correctness:

Reviewed-by: Oleg Nesterov <oleg@redhat.com>



> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> ---
>  kernel/kmod.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 0ac67a5..68a4ca4 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -71,7 +71,7 @@ char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
>
>  static void free_modprobe_argv(struct subprocess_info *info)
>  {
> -	kfree(info->argv[3]); /* check call_modprobe() */
> +	kfree(info->argv[4]); /* check call_modprobe() */
>  	kfree(info->argv);
>  }
>
> @@ -85,7 +85,7 @@ static int call_modprobe(char *module_name, int wait)
>  		NULL
>  	};
>
> -	char **argv = kmalloc(sizeof(char *[5]), GFP_KERNEL);
> +	char **argv = kmalloc(sizeof(char *[6]), GFP_KERNEL);
>  	if (!argv)
>  		goto out;
>
> @@ -95,9 +95,10 @@ static int call_modprobe(char *module_name, int wait)
>
>  	argv[0] = modprobe_path;
>  	argv[1] = "-q";
> -	argv[2] = "--";
> -	argv[3] = module_name;	/* check free_modprobe_argv() */
> -	argv[4] = NULL;
> +	argv[2] = "-b";
> +	argv[3] = "--";
> +	argv[4] = module_name;	/* check free_modprobe_argv() */
> +	argv[5] = NULL;
>
>  	info = call_usermodehelper_setup(modprobe_path, argv, envp, GFP_KERNEL,
>  					 NULL, free_modprobe_argv, NULL);
>
>

