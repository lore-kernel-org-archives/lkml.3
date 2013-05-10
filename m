Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab3EJNQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:16:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab3EJNQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:16:01 -0400
Date: Fri, 10 May 2013 15:12:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] init/Kconfig: Add option to set modprobe command
Message-ID: <20130510131247.GA1306@redhat.com>
References: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com> <1368159316-31744-3-git-send-email-lucas.de.marchi@gmail.com> <20130510125826.GA553@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510125826.GA553@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10, Oleg Nesterov wrote:
>
> On 05/10, Lucas De Marchi wrote:
> >
> > -char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe -q --";
> > +char modprobe_path[KMOD_PATH_LEN] = CONFIG_DEFAULT_MODULE_LOAD_BIN;
>
> But even after 1/3 and 2/3 this can break free_modprobe_argv() ?
> It assumes that argv[3] is module_name.

I'd suggest the patch below instead of 1 + 2. We can simply change
call_modprobe() to use kasprintf() + argv_split().

Oleg.

 kmod.c |   38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

--- x/kernel/kmod.c
+++ x/kernel/kmod.c
@@ -64,20 +64,16 @@ static DECLARE_RWSEM(umhelper_sem);
 
 #ifdef CONFIG_MODULES
 
-/*
-	modprobe_path is set via /proc/sys.
-*/
-char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
+/* modprobe_path is set via /proc/sys/kernel/modprobe */
+char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe -q --";
 
 static void free_modprobe_argv(struct subprocess_info *info)
 {
-	kfree(info->argv[3]); /* check call_modprobe() */
-	kfree(info->argv);
+	argv_free(info->argv);
 }
 
 static int call_modprobe(char *module_name, int wait)
 {
-	struct subprocess_info *info;
 	static char *envp[] = {
 		"HOME=/",
 		"TERM=linux",
@@ -85,31 +81,29 @@ static int call_modprobe(char *module_na
 		NULL
 	};
 
-	char **argv = kmalloc(sizeof(char *[5]), GFP_KERNEL);
-	if (!argv)
-		goto out;
+	struct subprocess_info *info;
+	char **argv;
+	char *args;
 
-	module_name = kstrdup(module_name, GFP_KERNEL);
-	if (!module_name)
-		goto free_argv;
+	args = kasprintf(GFP_KERNEL, "%s %s", modprobe_path, module_name);
+	if (!args)
+		goto out;
 
-	argv[0] = modprobe_path;
-	argv[1] = "-q";
-	argv[2] = "--";
-	argv[3] = module_name;	/* check free_modprobe_argv() */
-	argv[4] = NULL;
+	argv = argv_split(GFP_KERNEL, args, NULL);
+	if (!argv)
+		goto free_args;
 
 	info = call_usermodehelper_setup(modprobe_path, argv, envp, GFP_KERNEL,
 					 NULL, free_modprobe_argv, NULL);
 	if (!info)
-		goto free_module_name;
+		goto free_argv;
 
 	return call_usermodehelper_exec(info, wait | UMH_KILLABLE);
 
-free_module_name:
-	kfree(module_name);
 free_argv:
-	kfree(argv);
+	argv_free(argv);
+free_args:
+	kfree(args);
 out:
 	return -ENOMEM;
 }

