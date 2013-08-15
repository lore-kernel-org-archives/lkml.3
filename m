Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab3HONMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:12:39 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:34012 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757471Ab3HONMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:12:37 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Erik Gilling <konkers@android.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Colin Cross <ccross@google.com>
Subject: [PATCH v2 04/10] android/sync: use get_unused_fd_flags(O_CLOEXEC) instead of get_unused_fd()
Date: Thu, 15 Aug 2013 15:10:54 +0200
Message-Id: <a62f8c4d9c9f85d26517370ac01dbcce51361a06.1376327678.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1376327678.git.ydroneaud@opteya.com>
References: <cover.1376327678.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1376327678.git.ydroneaud@opteya.com>
References: <cover.1376327678.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macro get_unused_fd() is used to allocate a file descriptor with
default flags. Those default flags (0) can be "unsafe":
O_CLOEXEC must be used by default to not leak file descriptor
across exec().

Instead of macro get_unused_fd(), functions anon_inode_getfd()
or get_unused_fd_flags() should be used with flags given by userspace.
If not possible, flags should be set to O_CLOEXEC to provide userspace
with a default safe behavor.

In a further patch, get_unused_fd() will be removed so that
new code start using anon_inode_getfd() or get_unused_fd_flags()
with correct flags.

This patch replaces calls to get_unused_fd() with call to
get_unused_fd_flags(O_CLOEXEC) following advice from Erik Gilling.

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Colin Cross <ccross@google.com>
Link: http://lkml.kernel.org/r/CACSP8SjXGMk2_kX_+RgzqqQwqKernvF1Wt3K5tw991W5dfAnCA@mail.gmail.com
Link: http://lkml.kernel.org/r/cover.1376327678.git.ydroneaud@opteya.com

---
 drivers/staging/android/sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 2996077..38e5d3b 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -697,7 +697,7 @@ static long sync_fence_ioctl_wait(struct sync_fence *fence, unsigned long arg)
 
 static long sync_fence_ioctl_merge(struct sync_fence *fence, unsigned long arg)
 {
-	int fd = get_unused_fd();
+	int fd = get_unused_fd_flags(O_CLOEXEC);
 	int err;
 	struct sync_fence *fence2, *fence3;
 	struct sync_merge_data data;
-- 
1.8.3.1

