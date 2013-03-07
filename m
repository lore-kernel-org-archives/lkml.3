Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab3CGCFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 21:05:34 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:43326 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3CGCFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 21:05:33 -0500
MIME-Version: 1.0
In-Reply-To: <20130225180802.GA6160@redhat.com>
References: <1361802350-9299-1-git-send-email-lucas.demarchi@profusion.mobi>
 <20130225160642.GA31806@redhat.com> <CAMOw1v7S07YOLQaKBBSHkCqhf1JSB1ZabMeMUJagb4E8841opQ@mail.gmail.com>
 <20130225180802.GA6160@redhat.com>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Wed, 6 Mar 2013 23:05:12 -0300
Message-ID: <CAMOw1v40=2zdyXuL1USzvHwNH+34uk+7P5Vxaa1fBJNZiHc++g@mail.gmail.com>
Subject: Re: [PATCH] usermodehelper: Fix -ENOMEM return logic
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Mon, Feb 25, 2013 at 3:08 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/25, Lucas De Marchi wrote:
>>
>> Yep. The current interface is confusing. I agree that a separate
>> setup() + exec() would make more sense.
>
> Great,
>
>> > @@ -98,8 +98,14 @@ static int call_modprobe(char *module_na
>> >         argv[3] = module_name;  /* check free_modprobe_argv() */
>> >         argv[4] = NULL;
>> >
>> > -       return call_usermodehelper_fns(modprobe_path, argv, envp,
>> > -               wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
>> > +       info = call_usermodehelper_setup(...); // better name, please...
>> > +       if (!info)
>> > +               goto free_modname;
>> > +
>> > +       return call_usermodehelper_exec(info, wait);
>>
>> I'd say that in these cases the "call_" prefix has no meaning, and we
>> could just use a "usermodehelper" as the namespace.
>
> Oh, I agree with any naming.
>
> So, I hope you will send v2. I'd suggest to split the fixes. 1/3
> should create/export the new helpers, and 2-3 fix should call_modprobe()
> and call_usermodehelper_keys(). But this is up to you, I won't insist.

I was implementing this today, but looking into call_modprobe(), it is
never called with UMH_NO_WAIT. Doesn't it mean we can use a similar
trick as you used in __orderly_poweroff()? Then something similar to
this would be sufficient in this case (whitespace damaged):

diff --git a/kernel/kmod.c b/kernel/kmod.c
index b39f240..e4d6f6f 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -69,12 +69,6 @@ static DECLARE_RWSEM(umhelper_sem);
 */
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";

-static void free_modprobe_argv(struct subprocess_info *info)
-{
-	kfree(info->argv[3]); /* check call_modprobe() */
-	kfree(info->argv);
-}
-
 static int call_modprobe(char *module_name, int wait)
 {
 	static char *envp[] = {
@@ -83,6 +77,7 @@ static int call_modprobe(char *module_name, int wait)
 		"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
 		NULL
 	};
+	int ret = -ENOMEM;

 	char **argv = kmalloc(sizeof(char *[5]), GFP_KERNEL);
 	if (!argv)
@@ -98,12 +93,13 @@ static int call_modprobe(char *module_name, int wait)
 	argv[3] = module_name;	/* check free_modprobe_argv() */
 	argv[4] = NULL;

-	return call_usermodehelper_fns(modprobe_path, argv, envp,
-		wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
+	ret = call_usermodehelper(modprobe_path, argv, envp,
+				  wait | UMH_KILLABLE);
+	kfree(module_name);
 free_argv:
 	kfree(argv);
 out:
-	return -ENOMEM;
+	return ret;
 }

 /**


Lucas De Marchi
