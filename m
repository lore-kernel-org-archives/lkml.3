Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaAPKsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:48:46 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:53741 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaAPKso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:48:44 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssVY9SQsClBrtp5eFYXU7YfNKMAfocpEeot7SjdQ==
X-RZG-CLASS-ID: mo00
Date: Thu, 16 Jan 2014 11:48:41 +0100
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140116104841.GA21768@aepfle.de>
References: <1389728116-21337-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1389728116-21337-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, K. Y. Srinivasan wrote:

> Implement the file copy service for Linux guests on Hyper-V. This permits the
> host to copy a file (over VMBUS) into the guest. This facility is part of
> "guest integration services" supported on the Windows platform.
> Here is a link that provides additional details on this functionality:

The change below fixes some warnings in the daemon code.
Compile tested only.
I also think the newlines in some of the syslog calls should be removed.

Olaf

    
hv_fcopy_daemon.c: In function 'hv_start_fcopy':
hv_fcopy_daemon.c:44:3: warning: format '%s' expects argument of type 'char *', but argument 3 has type '__u16 *' [-Wformat=]
   smsg->file_name);
   ^
hv_fcopy_daemon.c:44:3: warning: format '%s' expects argument of type 'char *', but argument 5 has type '__u16 *' [-Wformat=]
hv_fcopy_daemon.c:57:6: warning: format '%s' expects argument of type 'char *', but argument 3 has type '__u16 *' [-Wformat=]
      errno, strerror(errno));
      ^
hv_fcopy_daemon.c:61:4: warning: format '%s' expects argument of type 'char *', but argument 3 has type '__u16 *' [-Wformat=]
    syslog(LOG_ERR, "Invalid path: %s\n", smsg->path_name);
    ^
hv_fcopy_daemon.c: In function 'main':
hv_fcopy_daemon.c:117:8: warning: ignoring return value of 'daemon', declared with attribute warn_unused_result [-Wunused-result]
  daemon(1, 0);
        ^
hv_fcopy_daemon.c:132:7: warning: ignoring return value of 'write', declared with attribute warn_unused_result [-Wunused-result]
  write(fcopy_fd, &version, sizeof(int));
       ^
hv_fcopy_daemon.c:171:9: warning: ignoring return value of 'pwrite', declared with attribute warn_unused_result [-Wunused-result]
   pwrite(fcopy_fd, &error, sizeof(int), 0);
         ^

Signed-off-by: Olaf Hering <olaf@aepfle.de>

diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
index c0e5c90..d1fadb7 100644
--- a/tools/hv/hv_fcopy_daemon.c
+++ b/tools/hv/hv_fcopy_daemon.c
@@ -35,14 +35,14 @@
 #include <dirent.h>
 
 static int target_fd;
-char target_fname[W_MAX_PATH];
+static char target_fname[W_MAX_PATH];
 
 static int hv_start_fcopy(struct hv_start_fcopy *smsg)
 {
 	int error = HV_E_FAIL;
 
-	sprintf(target_fname, "%s%s%s", smsg->path_name, "/",
-		smsg->file_name);
+	snprintf(target_fname, sizeof(target_fname), "%s/%s",
+			(char *)smsg->path_name, (char*)smsg->file_name);
 
 	syslog(LOG_INFO, "Target file name: %s\n", target_fname);
 	/*
@@ -54,12 +54,12 @@ static int hv_start_fcopy(struct hv_start_fcopy *smsg)
 			if (mkdir((char *)smsg->path_name, 0755)) {
 				syslog(LOG_ERR,
 					"Failed to create '%s'; error: %d %s\n",
-					smsg->path_name,
+					(char *)smsg->path_name,
 					errno, strerror(errno));
 				goto done;
 			}
 		} else {
-			syslog(LOG_ERR, "Invalid path: %s\n", smsg->path_name);
+			syslog(LOG_ERR, "Invalid path: %s", (char *)smsg->path_name);
 			goto done;
 		}
 	}
@@ -115,7 +115,8 @@ int main(void)
 	char *buffer[4096 * 2];
 	struct hv_fcopy_hdr *in_msg;
 
-	daemon(1, 0);
+	if (daemon(1, 0))
+		return 1;
 	openlog("HV_FCOPY", 0, LOG_USER);
 	syslog(LOG_INFO, "HV_FCOPY starting; pid is:%d", getpid());
 
@@ -130,7 +131,10 @@ int main(void)
 	/*
 	 * Register with the kernel.
 	 */
-	write(fcopy_fd, &version, sizeof(int));
+	if (write(fcopy_fd, &version, sizeof(int)) != sizeof(int)) {
+		syslog(LOG_ERR, "write failed: %s",strerror(errno));
+		exit(EXIT_FAILURE);
+	}
 
 	while (1) {
 		/*
@@ -169,6 +173,9 @@ int main(void)
 
 		}
 
-		pwrite(fcopy_fd, &error, sizeof(int), 0);
+		if (pwrite(fcopy_fd, &error, sizeof(int), 0) != sizeof(int)) {
+			syslog(LOG_ERR, "pwrite failed: %s",strerror(errno));
+			exit(EXIT_FAILURE);
+		}
 	}
 }
