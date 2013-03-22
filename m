Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822Ab3CVQO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:14:59 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:45898 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933480Ab3CVQO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:14:58 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJwKkjb5rDUwdDCeCg=
X-RZG-CLASS-ID: mo00
Date: Fri, 22 Mar 2013 17:14:53 +0100
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH V2 1/1] Drivers: hv: Add a new driver to support host
 initiated backup
Message-ID: <20130322161453.GA2767@aepfle.de>
References: <1363375806-19979-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1363375806-19979-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21.rev5641 (2013-02-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, K. Y. Srinivasan wrote:

> This driver has a user-level component (daemon) that invokes the appropriate

This change fixes a few compile errors:

hv_vss_daemon.c:64:15: warning: unknown escape sequence '\/'
hv_vss_daemon.c:64:15: warning: unknown escape sequence '\/'
hv_vss_daemon.c: In function 'vss_operate':
hv_vss_daemon.c:66: warning: 'return' with no value, in function returning non-void
hv_vss_daemon.c: In function 'main':
hv_vss_daemon.c:130: warning: ignoring return value of 'daemon', declared with attribute warn_unused_result
hv_vss_daemon.c: In function 'vss_operate':
hv_vss_daemon.c:47: warning: 'fs_op' may be used uninitialized in this function

Signed-off-by: Olaf Hering <olaf@aepfle.de>

--- a/tools/hv/hv_vss_daemon.c	2013-03-22 17:06:41.000000000 +0100
+++ b/tools/hv/hv_vss_daemon.c	2013-03-22 17:09:41.000000000 +0100
@@ -51,7 +51,7 @@ static int vss_operate(int operation)
 	FILE *file;
 	char *p;
 	char *x;
-	int error;
+	int error = -1;
 
 	switch (operation) {
 	case VSS_OP_FREEZE:
@@ -60,11 +60,13 @@ static int vss_operate(int operation)
 	case VSS_OP_THAW:
 		fs_op = "-u ";
 		break;
+	default:
+		goto out;
 	}
 
-	file = popen("mount | awk '/^\/dev\// { print $3}'", "r");
+	file = popen("mount | awk '/^\\/dev\\// { print $3}'", "r");
 	if (file == NULL)
-		return;
+		goto out;
 
 	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
 		x = strchr(p, '\n');
@@ -82,6 +84,7 @@ static int vss_operate(int operation)
 	syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
 	error = system(cmd);
 
+out:
 	return error;
 }
 
@@ -128,7 +131,9 @@ int main(void)
 	int	op;
 	struct hv_vss_msg *vss_msg;
 
-	daemon(1, 0);
+	if (daemon(1, 0))
+		return 1;
+
 	openlog("Hyper-V VSS", 0, LOG_USER);
 	syslog(LOG_INFO, "VSS starting; pid is:%d", getpid());
 
