Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbbAGCR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:17:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbbAGCQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:16:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 3.17 37/73] isofs: Fix unchecked printing of ER records
Date: Tue,  6 Jan 2015 18:15:58 -0800
Message-Id: <20150107021558.644351449@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 4e2024624e678f0ebb916e6192bd23c1f9fdf696 upstream.

We didn't check length of rock ridge ER records before printing them.
Thus corrupted isofs image can cause us to access and print some memory
behind the buffer with obvious consequences.

Reported-and-tested-by: Carl Henrik Lunde <chlunde@ping.uio.no>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/isofs/rock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -362,6 +362,9 @@ repeat:
 			rs.cont_size = isonum_733(rr->u.CE.size);
 			break;
 		case SIG('E', 'R'):
+			/* Invalid length of ER tag id? */
+			if (rr->u.ER.len_id + offsetof(struct rock_ridge, u.ER.data) > rr->len)
+				goto out;
 			ISOFS_SB(inode->i_sb)->s_rock = 1;
 			printk(KERN_DEBUG "ISO 9660 Extensions: ");
 			{


