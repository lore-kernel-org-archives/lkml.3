Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab3JKKqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:46:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58824 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab3JKKoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:44:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 094/100] staging: comedi: ni_65xx: (bug fix) confine insn_bits to one subdevice
Date: Fri, 11 Oct 2013 11:42:04 +0100
Message-Id: <1381488130-30235-95-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 677a31565692d596ef42ea589b53ba289abf4713 upstream.

The `insn_bits` handler `ni_65xx_dio_insn_bits()` has a `for` loop that
currently writes (optionally) and reads back up to 5 "ports" consisting
of 8 channels each.  It reads up to 32 1-bit channels but can only read
and write a whole port at once - it needs to handle up to 5 ports as the
first channel it reads might not be aligned on a port boundary.  It
breaks out of the loop early if the next port it handles is beyond the
final port on the card.  It also breaks out early on the 5th port in the
loop if the first channel was aligned.  Unfortunately, it doesn't check
that the current port it is dealing with belongs to the comedi subdevice
the `insn_bits` handler is acting on.  That's a bug.

Redo the `for` loop to terminate after the final port belonging to the
subdevice, changing the loop variable in the process to simplify things
a bit.  The `for` loop could now try and handle more than 5 ports if the
subdevice has more than 40 channels, but the test `if (bitshift >= 32)`
ensures it will break out early after 4 or 5 ports (depending on whether
the first channel is aligned on a port boundary).  (`bitshift` will be
between -7 and 7 inclusive on the first iteration, increasing by 8 for
each subsequent operation.)

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Ian: This patch applies to kernels 2.6.34.y through to 3.5.y inclusive.
  Similar patch already queued for 3.10.y and 3.11.y by Greg-KH.
  I can post similar patches for kernels 3.6.y to 3.9.y on request.
  Similar patch for 2.6.32.y ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/drivers/ni_65xx.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index 0d27a93..c36efe0 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -411,29 +411,25 @@ static int ni_65xx_dio_insn_bits(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
-	unsigned base_bitfield_channel;
-	const unsigned max_ports_per_bitfield = 5;
+	int base_bitfield_channel;
 	unsigned read_bits = 0;
-	unsigned j;
+	int last_port_offset = ni_65xx_port_by_channel(s->n_chan - 1);
+	int port_offset;
+
 	if (insn->n != 2)
 		return -EINVAL;
 	base_bitfield_channel = CR_CHAN(insn->chanspec);
-	for (j = 0; j < max_ports_per_bitfield; ++j) {
-		const unsigned port_offset =
-			ni_65xx_port_by_channel(base_bitfield_channel) + j;
-		const unsigned port =
-			sprivate(s)->base_port + port_offset;
-		unsigned base_port_channel;
+	for (port_offset = ni_65xx_port_by_channel(base_bitfield_channel);
+	     port_offset <= last_port_offset; port_offset++) {
+		unsigned port = sprivate(s)->base_port + port_offset;
+		int base_port_channel = port_offset * ni_65xx_channels_per_port;
 		unsigned port_mask, port_data, port_read_bits;
-		int bitshift;
-		if (port >= ni_65xx_total_num_ports(board(dev)))
+		int bitshift = base_port_channel - base_bitfield_channel;
+
+		if (bitshift >= 32)
 			break;
-		base_port_channel = port_offset * ni_65xx_channels_per_port;
 		port_mask = data[0];
 		port_data = data[1];
-		bitshift = base_port_channel - base_bitfield_channel;
-		if (bitshift >= 32 || bitshift <= -32)
-			break;
 		if (bitshift > 0) {
 			port_mask >>= bitshift;
 			port_data >>= bitshift;
-- 
1.8.3.2

