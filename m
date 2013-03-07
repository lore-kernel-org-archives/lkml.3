Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361Ab3CGTir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 14:38:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932724Ab3CGTiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 14:38:46 -0500
Date: Thu, 7 Mar 2013 20:37:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usermodehelper: Fix -ENOMEM return logic
Message-ID: <20130307193701.GA20385@redhat.com>
References: <1361802350-9299-1-git-send-email-lucas.demarchi@profusion.mobi> <20130225160642.GA31806@redhat.com> <CAMOw1v7S07YOLQaKBBSHkCqhf1JSB1ZabMeMUJagb4E8841opQ@mail.gmail.com> <20130225180802.GA6160@redhat.com> <CAMOw1v40=2zdyXuL1USzvHwNH+34uk+7P5Vxaa1fBJNZiHc++g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMOw1v40=2zdyXuL1USzvHwNH+34uk+7P5Vxaa1fBJNZiHc++g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lucas,

On 03/06, Lucas De Marchi wrote:
>
> On Mon, Feb 25, 2013 at 3:08 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > So, I hope you will send v2. I'd suggest to split the fixes. 1/3
> > should create/export the new helpers, and 2-3 fix should call_modprobe()
> > and call_usermodehelper_keys(). But this is up to you, I won't insist.
>
> I was implementing this today, but looking into call_modprobe(), it is
> never called with UMH_NO_WAIT.

wait == T means UMH_WAIT_PROC, so we can't simply rely on CLONE_VFORK.
But probably we can rely on sys_wait4.

However,

> @@ -98,12 +93,13 @@ static int call_modprobe(char *module_name, int wait)
>  	argv[3] = module_name;	/* check free_modprobe_argv() */
>  	argv[4] = NULL;
> 
> -	return call_usermodehelper_fns(modprobe_path, argv, envp,
> -		wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
> +	ret = call_usermodehelper(modprobe_path, argv, envp,
> +				  wait | UMH_KILLABLE);
> +	kfree(module_name);

Please note UMH_KILLABLE. call_usermodehelper() can be interrupted
and even UMH_WAIT_EXEC case is not safe. If call_modprobe() is killed
we can return while the workqueue thread still tries to clone/exec/etc.

Oleg.

