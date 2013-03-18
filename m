Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141Ab3CRWBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:01:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab3CRVGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 15/75] staging: comedi: dt9812: use CR_CHAN() for channel number
Date: Mon, 18 Mar 2013 14:06:38 -0700
Message-Id: <20130318210511.328277687@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 564c526a1bed5e42b5cd52cfe1752c4296ef17a6 upstream.

As pointed out by Dan Carpenper in
<http://driverdev.linuxdriverproject.org/pipermail/devel/2013-February/036025.html>,
the dt9812 comedi driver's use of the `chanspec` member of `struct
comedi_insn` as a channel number is incorrect.  Change it to use
`CR_CHAN(insn->chanspec)` as the channel number (where `insn` is a
pointer to the `struct comedi_insn` being processed).

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anders Blomdell <anders.blomdell@control.lth.se>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/dt9812.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -948,12 +948,13 @@ static int dt9812_di_rinsn(struct comedi
 			   unsigned int *data)
 {
 	struct comedi_dt9812 *devpriv = dev->private;
+	unsigned int channel = CR_CHAN(insn->chanspec);
 	int n;
 	u8 bits = 0;
 
 	dt9812_digital_in(devpriv->slot, &bits);
 	for (n = 0; n < insn->n; n++)
-		data[n] = ((1 << insn->chanspec) & bits) != 0;
+		data[n] = ((1 << channel) & bits) != 0;
 	return n;
 }
 
@@ -962,12 +963,13 @@ static int dt9812_do_winsn(struct comedi
 			   unsigned int *data)
 {
 	struct comedi_dt9812 *devpriv = dev->private;
+	unsigned int channel = CR_CHAN(insn->chanspec);
 	int n;
 	u8 bits = 0;
 
 	dt9812_digital_out_shadow(devpriv->slot, &bits);
 	for (n = 0; n < insn->n; n++) {
-		u8 mask = 1 << insn->chanspec;
+		u8 mask = 1 << channel;
 
 		bits &= ~mask;
 		if (data[n])
@@ -982,13 +984,13 @@ static int dt9812_ai_rinsn(struct comedi
 			   unsigned int *data)
 {
 	struct comedi_dt9812 *devpriv = dev->private;
+	unsigned int channel = CR_CHAN(insn->chanspec);
 	int n;
 
 	for (n = 0; n < insn->n; n++) {
 		u16 value = 0;
 
-		dt9812_analog_in(devpriv->slot, insn->chanspec, &value,
-				 DT9812_GAIN_1);
+		dt9812_analog_in(devpriv->slot, channel, &value, DT9812_GAIN_1);
 		data[n] = value;
 	}
 	return n;
@@ -999,12 +1001,13 @@ static int dt9812_ao_rinsn(struct comedi
 			   unsigned int *data)
 {
 	struct comedi_dt9812 *devpriv = dev->private;
+	unsigned int channel = CR_CHAN(insn->chanspec);
 	int n;
 	u16 value;
 
 	for (n = 0; n < insn->n; n++) {
 		value = 0;
-		dt9812_analog_out_shadow(devpriv->slot, insn->chanspec, &value);
+		dt9812_analog_out_shadow(devpriv->slot, channel, &value);
 		data[n] = value;
 	}
 	return n;
@@ -1015,10 +1018,11 @@ static int dt9812_ao_winsn(struct comedi
 			   unsigned int *data)
 {
 	struct comedi_dt9812 *devpriv = dev->private;
+	unsigned int channel = CR_CHAN(insn->chanspec);
 	int n;
 
 	for (n = 0; n < insn->n; n++)
-		dt9812_analog_out(devpriv->slot, insn->chanspec, data[n]);
+		dt9812_analog_out(devpriv->slot, channel, data[n]);
 	return n;
 }
 


