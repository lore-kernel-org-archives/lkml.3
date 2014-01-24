Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaAXNrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:47:37 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:38450 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbaAXNrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:47:36 -0500
Message-ID: <52E26EF3.1090901@linux.vnet.ibm.com>
Date: Fri, 24 Jan 2014 14:47:31 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.13: BUG: unable to handle kernel paging request at 00000000b4343e88
References: <alpine.SOC.1.00.1401211228410.25614@math.ut.ee> <20140121141037.f76dba61212c5597ff733207@linux-foundation.org> <alpine.SOC.1.00.1401221731150.3033@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1401221731150.3033@math.ut.ee>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012413-4966-0000-0000-0000082B8256
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.01.2014 16:33, Meelis Roos wrote:
>> It looks like gcov exploded when running a module's constructors or
>> init function, but I'm unable to work out which module it was :(
> [...]
> 
>> Maybe it's tg3.
>>
>> Could you add `ignore_loglevel' to the kernel boot parameters?  That
>> should make all pr_debug()s come out and they include the module's
>> name.

I'm not sure if this related, but all 3 kernel logs consistently contain
this error message:

> [    0.617401] gcov: could not create file

which should only be shown in case of severe out-of-memory situations or
duplicate object file names.

Could you retry with the following patch applied (2 times if possible)
and send dmesg output?

-----
diff -Naurp a/kernel/gcov/base.c b/kernel/gcov/base.c
--- a/kernel/gcov/base.c
+++ b/kernel/gcov/base.c
@@ -31,6 +31,7 @@ void __gcov_init(struct gcov_info *info)
 {
 	static unsigned int gcov_version;

+	pr_warn("__gcov_init(%s): enter\n", gcov_info_filename(info));
 	mutex_lock(&gcov_lock);
 	if (gcov_version == 0) {
 		gcov_version = gcov_info_version(info);
@@ -48,6 +49,7 @@ void __gcov_init(struct gcov_info *info)
 	if (gcov_events_enabled)
 		gcov_event(GCOV_ADD, info);
 	mutex_unlock(&gcov_lock);
+	pr_warn("__gcov_init(%s): exit\n", gcov_info_filename(info));
 }
 EXPORT_SYMBOL(__gcov_init);

diff -Naurp a/kernel/gcov/fs.c b/kernel/gcov/fs.c
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -450,7 +450,7 @@ static struct gcov_node *new_node(struct
 	} else
 		node->dentry = debugfs_create_dir(node->name, parent->dentry);
 	if (!node->dentry) {
-		pr_warn("could not create file\n");
+		pr_warn("could not create file (%s)\n", node->name);
 		kfree(node);
 		return NULL;
 	}

