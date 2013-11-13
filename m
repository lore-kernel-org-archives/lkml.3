Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab3KMII7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:08:59 -0500
Received: from dmz-mailsec-scanner-2.mit.edu ([18.9.25.13]:58644 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758826Ab3KMIIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:08:38 -0500
X-AuditID: 1209190d-b7ef66d000000c40-12-52833385d299
Date: Wed, 13 Nov 2013 03:08:35 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] random: tighten bound on random_read_wakeup_thresh
Message-ID: <20131113080835.GV16018@ringworld.MIT.EDU>
References: <cover.1384329436.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1384329436.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsUixG6nottq3BxksOWSqcXlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mr4NmsWc0E/V8XPT71sDYxLOLoYOTkkBEwkjs++wg5hi0lcuLee
	rYuRi0NIYDaTxLoHy1ghnI2MEndeT2OGcH4xSuw6/pcJpIVFQFXi6pr3YDabgILEj/nrmEFs
	EQFliVUzN4HFmYHiv+5tYgWxhQXcJTa//A1WwytgJnFq91MwW0jAQGLj/glQcUGJkzOfsED0
	aknc+PcSaA4HkC0tsfwf2NWcAoYSkzYcBRspKqAiMeXkNrYJjIKzkHTPQtI9C6F7ASPzKkbZ
	lNwq3dzEzJzi1GTd4uTEvLzUIl0jvdzMEr3UlNJNjKBA5ZTk3cH47qDSIUYBDkYlHl6LmKYg
	IdbEsuLK3EOMkhxMSqK8TjrNQUJ8SfkplRmJxRnxRaU5qcWHGCU4mJVEeA8IA+V4UxIrq1KL
	8mFS0hwsSuK8Nznsg4QE0hNLUrNTUwtSi2CyMhwcShK8FkZAjYJFqempFWmZOSUIaSYOTpDh
	PEDDRUBqeIsLEnOLM9Mh8qcYFaXEeWNAEgIgiYzSPLheWCJ5xSgO9IowryhIFQ8wCcF1vwIa
	zAQ02KK4CWRwSSJCSqqBMeyXmPzXOHGNz4VqdRw9Js9mx7w4Hbi6eL3QJFmH73t2eml+XWMf
	n3XfKcwrbu9m3p1tS44sWDpj3+Rfaxft+GfVmNb1L/nlwR0XxSac/cqmdSJjv8MbB+nbM0zk
	OHoZIqS3SX/7Ynlw6dqfRQYPUkRsl15tiTjWb/3jquzdYqmj0i0LtG8+W6fEUpyRaKjFXFSc
	CACDbh7C/wIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use this value in a few places other than its literal meaning,
in particular in _xfer_secondary_pool() as a minimum number of
bits to pull from the input pool at a time into either output
pool.  It doesn't make sense to pull more bits than the whole size
of an output pool.

We could and possibly should separate the quantities "how much
should the input pool have to have to wake up /dev/random readers"
and "how much should we transfer from the input to an output pool
at a time", but nobody is likely to be sad they can't set the first
quantity to more than 1024 bits, so for now just limit them both.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1f43f9e..865c8db 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1494,7 +1494,7 @@ EXPORT_SYMBOL(generate_random_uuid);
 #include <linux/sysctl.h>
 
 static int min_read_thresh = 8, min_write_thresh;
-static int max_read_thresh = INPUT_POOL_WORDS * 32;
+static int max_read_thresh = OUTPUT_POOL_WORDS * 32;
 static int max_write_thresh = INPUT_POOL_WORDS * 32;
 static char sysctl_bootid[16];
 
-- 
1.8.3.2

