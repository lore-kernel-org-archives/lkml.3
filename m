Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab3CGUJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:09:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab3CGUJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:09:06 -0500
Date: Thu, 7 Mar 2013 21:07:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usermodehelper: Fix -ENOMEM return logic
Message-ID: <20130307200722.GA22072@redhat.com>
References: <1361802350-9299-1-git-send-email-lucas.demarchi@profusion.mobi> <20130225160642.GA31806@redhat.com> <CAMOw1v7S07YOLQaKBBSHkCqhf1JSB1ZabMeMUJagb4E8841opQ@mail.gmail.com> <20130225180802.GA6160@redhat.com> <CAMOw1v40=2zdyXuL1USzvHwNH+34uk+7P5Vxaa1fBJNZiHc++g@mail.gmail.com> <20130307193701.GA20385@redhat.com> <CAMOw1v6HkAPUpebno7tj0wD4=+C_tRgSLmrUwPVdKUqjy4vyYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMOw1v6HkAPUpebno7tj0wD4=+C_tRgSLmrUwPVdKUqjy4vyYg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07, Lucas De Marchi wrote:
>
> On Thu, Mar 7, 2013 at 4:37 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> >> @@ -98,12 +93,13 @@ static int call_modprobe(char *module_name, int wait)
> >>       argv[3] = module_name;  /* check free_modprobe_argv() */
> >>       argv[4] = NULL;
> >>
> >> -     return call_usermodehelper_fns(modprobe_path, argv, envp,
> >> -             wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
> >> +     ret = call_usermodehelper(modprobe_path, argv, envp,
> >> +                               wait | UMH_KILLABLE);
> >> +     kfree(module_name);
> >
> > Please note UMH_KILLABLE. call_usermodehelper() can be interrupted
> > and even UMH_WAIT_EXEC case is not safe. If call_modprobe() is killed
> > we can return while the workqueue thread still tries to clone/exec/etc.
>
> Even if it's killed, we would just free the resource we allocated
> before.

Yes, and after that ____call_usermodehelper() can do
do_execve(module_name) ?

> It would not be safe if we allocated in the init function and
> freed in the cleanup.

But we do? We free this memory in cleanup ? And I was allocated by us.

sub_info itself can't go away (if you meant this), but
sub_info->path/argv/envp can.

> Or am I missing something?

Or me...

Oleg.

