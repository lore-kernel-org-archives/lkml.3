Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbaJRPYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 11:24:19 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:8484 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbaJRPYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 11:24:16 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/4] fs: fcntl/fadvice fixes v2
Date: Sat, 18 Oct 2014 19:21:24 +0400
Message-Id: <1413645688-13524-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fcntl(F_SETFL) and fadvise performs direct manipulation with file's internals.
w/o notifying to fs layer. This behavior be not be suitable for some filesystems
(mostly stack-fs like ecryptfs, unionfs, etc). Let's introduce new ->set_flags()
callback for that purpose. This callback is responsible for flags check so
->check_flags() no longer required.

TOC:
 fs: fcntl add set_flags wrapper -v2
 fs: add fadvise file_operation
 ecryptfs: add fadvise/set_flags calbacks
 cifs: add set_flag callback

*OPEN ISSUE REMAINS*
This series does not fix all issues related with set_flags.
Race between fcntl(toggling O_DIRECT) vs write() is still possible
Usually O_DIRECT checked twice during call chain:
 ->xxx_file_write_iter
 --->__generic_file_write_iter
So we may end-up up with two different values. Some filesystems (btrfs/xfs)
avoid this issue by copy-pasting __generic_file_write_iter.
One of possible way to fix this issue it to save flags in kiocb->ki_flags
as we already do with ->ki_pos. And fixup all places accordingly.
I've calculated numbers of direct access to ->f_flags it is close to 150,
half of that number is ->open() methods. So patch would not be gigantic.
And finally here is my question to AlViro and Christoph and other VFS-people:
*Are you agree with that approach?* Please say your word.
