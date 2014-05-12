Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbaELC2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:28:44 -0400
Received: from 1wt.eu ([62.212.114.60]:34323 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbaELBl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:26 -0400
Message-Id: <20140512003200.933525990@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 007/143] staging: comedi: ni_65xx: (bug fix) confine insn_bits to one
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 subdevice

From: Ian Abbott <abbotti@mev.co.uk>

Commit 677a31565692d596ef42ea589b53ba289abf4713 upstream.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/comedi/drivers/ni_65xx.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index bbf75eb..bb23291 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -410,28 +410,25 @@ static int ni_65xx_dio_insn_bits(struct comedi_device *dev,
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
-		const unsigned port_offset = ni_65xx_port_by_channel(base_bitfield_channel) + j;
-		const unsigned port =
-		    sprivate(s)->base_port + port_offset;
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
1.7.12.2.21.g234cd45.dirty



