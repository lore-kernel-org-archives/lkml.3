Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab3LORbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 12:31:41 -0500
Received: from mailp.voltaire.com ([193.47.165.129]:58440 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751798Ab3LORbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 12:31:40 -0500
From: Doron Tsur <doront@mellanox.com>
To: linux-kernel@vger.kernel.org, levex@linux.com
Cc: itaib@mellanox.com, Doron Tsur <doront@mellanox.com>
Subject: [PATCH] include/uapi/linux/netlink.h -Wall -Wextra -Werror support fix
Date: Sun, 15 Dec 2013 19:31:34 +0200
Message-Id: <1387128694-14470-1-git-send-email-doront@mellanox.com>
X-Mailer: git-send-email 1.7.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For code using:
    #include <linux/netlink.h>
    NLMSG_OK
    -I<INSTALL_HDR_PATH>/include

Issue:
(nlh)->nlmsg_len is of type __u32, while len is of type int,
according to (len) >= (int)sizeof(struct nlmsghdr).
Hence (nlh)->nlmsg_len <= (len) sign-compare warning when using NLMSG_OK

Fix:
Add (int) casting:
-			   (nlh)->nlmsg_len <= (len))
+			   (int)(nlh)->nlmsg_len <= (len))

Test log:
Compilation environments:
Ubuntu 13.10, x86_64, gcc (Ubuntu/Linaro 4.8.1-10ubuntu9) 4.8.1
Ubuntu 13.04, x86_64, gcc (Ubuntu/Linaro 4.7.3-1ubuntu1) 4.7.3
[ -ftrack-macro-expansion=2 issue submitted:
  gcc.gnu.org/bugzilla/show_bug.cgi?id=59495 ]

Kernel headers installed at:
make -C .../linux-stable headers_install \
    INSTALL_HDR_PATH=/builds/kernel_tests_user_headers/

Pre-patch compilation:
gcc -Wall -Wextra -Werror
-I/builds/kernel_tests_pre_patch_user_headers/include
include-uapi-linux-netlink.h.test.c
In file included from include-uapi-linux-netlink.h.test.c:2:0:
include-uapi-linux-netlink.h.test.c: In function ‘main’:
/builds/kernel_tests_pre_patch_user_headers/include/linux/netlink.h:89:24:
error: comparison between signed and unsigned integer expressions
[-Werror=sign-compare]
       (nlh)->nlmsg_len <= (len))
                        ^
include-uapi-linux-netlink.h.test.c:26:5: note: in expansion of macro ‘NLMSG_OK’
     NLMSG_OK(&auxiliary_netlink_header, active_len));
     ^
cc1: all warnings being treated as errors

Post-patch:
$ gcc  -Wall -Wextra -Werror
-I/builds/kernel_tests_user_headers/include/
include-uapi-linux-netlink.h.test.c

$ ./a.out
nlmsg_len= 1, len = 1 NLMSG_OK(nlh,len) test result: 0
nlmsg_len= 1, len = 3000 NLMSG_OK(nlh,len) test result: 0
nlmsg_len= 3000, len = 1 NLMSG_OK(nlh,len) test result: 0
nlmsg_len= 3000, len = 3000 NLMSG_OK(nlh,len) test result: 1

Tested-by: Doron Tsur <doront@mellanox.com>
Signed-off-by: Doron Tsur <doront@mellanox.com>
---
 include/uapi/linux/netlink.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 1a85940..1884d4e 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -86,7 +86,7 @@ struct nlmsghdr {
 				  (struct nlmsghdr*)(((char*)(nlh)) + NLMSG_ALIGN((nlh)->nlmsg_len)))
 #define NLMSG_OK(nlh,len) ((len) >= (int)sizeof(struct nlmsghdr) && \
 			   (nlh)->nlmsg_len >= sizeof(struct nlmsghdr) && \
-			   (nlh)->nlmsg_len <= (len))
+			   (int)(nlh)->nlmsg_len <= (len))
 #define NLMSG_PAYLOAD(nlh,len) ((nlh)->nlmsg_len - NLMSG_SPACE((len)))
 
 #define NLMSG_NOOP		0x1	/* Nothing.		*/
-- 
1.7.1

