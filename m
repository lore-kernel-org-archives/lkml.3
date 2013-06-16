Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3FPRGL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 13:06:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42725 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3FPRGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 13:06:10 -0400
Date: Sun, 16 Jun 2013 18:06:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Krishna Gudipati <kgudipat@brocade.com>,
        Jing Huang <huangj@brocade.com>, Hiral Patel <hiralpat@cisco.com>,
        James Smart <James.Smart@Emulex.Com>
Subject: [pile of bugs] lseek(fd, n, SEEK_END) does *not* go to eof - n
Message-ID: <20130616170605.GQ4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When you copy some code, you are supposed to read it.  If nothing else,
there's a chance to spot and fix an obvious bug instead of sharing it...

X-Song: "I Got It From Agnes", by Tom Lehrer
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/net/ethernet/brocade/bna/bnad_debugfs.c b/drivers/net/ethernet/brocade/bna/bnad_debugfs.c
index 6e8bc9d..94d957d 100644
--- a/drivers/net/ethernet/brocade/bna/bnad_debugfs.c
+++ b/drivers/net/ethernet/brocade/bna/bnad_debugfs.c
@@ -244,7 +244,7 @@ bnad_debugfs_lseek(struct file *file, loff_t offset, int orig)
 		file->f_pos += offset;
 		break;
 	case 2:
-		file->f_pos = debug->buffer_len - offset;
+		file->f_pos = debug->buffer_len + offset;
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index 439c012..b63d534 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -186,7 +186,7 @@ bfad_debugfs_lseek(struct file *file, loff_t offset, int orig)
 		file->f_pos += offset;
 		break;
 	case 2:
-		file->f_pos = debug->buffer_len - offset;
+		file->f_pos = debug->buffer_len + offset;
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index adc1f7f..85e1ffd 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -174,7 +174,7 @@ static loff_t fnic_trace_debugfs_lseek(struct file *file,
 		pos = file->f_pos + offset;
 		break;
 	case 2:
-		pos = fnic_dbg_prt->buffer_len - offset;
+		pos = fnic_dbg_prt->buffer_len + offset;
 	}
 	return (pos < 0 || pos > fnic_dbg_prt->buffer_len) ?
 			  -EINVAL : (file->f_pos = pos);
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index f63f5ff..f525ecb 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1178,7 +1178,7 @@ lpfc_debugfs_lseek(struct file *file, loff_t off, int whence)
 		pos = file->f_pos + off;
 		break;
 	case 2:
-		pos = debug->len - off;
+		pos = debug->len + off;
 	}
 	return (pos < 0 || pos > debug->len) ? -EINVAL : (file->f_pos = pos);
 }
