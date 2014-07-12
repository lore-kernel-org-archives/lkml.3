Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaGLJU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 05:20:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbaGLJUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 05:20:24 -0400
Date: Sat, 12 Jul 2014 11:20:19 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: stub: Add support for SMBus block commands
Message-ID: <20140712112019.618d8a03@endymion.delvare>
In-Reply-To: <53BC4F15.9030608@roeck-us.net>
References: <1404742983-27303-1-git-send-email-linux@roeck-us.net>
	<20140708215453.0677d3ed@endymion.delvare>
	<53BC4F15.9030608@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Tue, 08 Jul 2014 13:05:41 -0700, Guenter Roeck wrote:
> On 07/08/2014 12:54 PM, Jean Delvare wrote:
> > Just one thing I have been thinking about while reviewing the updated
> > code... You decided to make the first SMBus block write select the
> > maximum block length, and you always use that for SMBus block reads.
> > However you accept partial writes. The fact that the order in which
> > writes are performed has an effect on which writes are accepted is
> > somewhat unexpected.
> >
> > Wouldn't it make more sense to accept all SMBus block writes,
> > regardless of the size (as long as it is within the limits of the SMBus
> > standard, of course)? Then the only thing left to decide is whether
> > SMBus block reads use the maximum size or the size of the most recent
> > SMBus block write.
> >
> > I suspect this would mimic the behavior of real chips better. What do
> > you think?
> 
> Not really sure what the expected behavior is. My original code
> accepted all writes and returned the most recent write, including
> the most recent write length. I thought this was untypical, and that
> it would be more typical for the chip to return a fixed length.
> But ultimately I don't really know, and I am fine either way.

I agree that different chips may behave differently and it is not
possible for i2c-stub to please everyone. However I do not think that
the current implementation mimics any actual chip behavior. So we might
as well switch to something more simple and more likely to please at
least one device driver:

From: Jean Delvare <jdelvare@suse.de>
Subject: i2c-stub: Allow the increasing SMBus block write length

This is no good reason to not allow SMBus block writes longer than the
first one was. Lift this limitation, this makes the code more simple.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Guenter Roeck <linux@roeck-us.net>
---
 Documentation/i2c/i2c-stub |    5 ++---
 drivers/i2c/i2c-stub.c     |   12 +++---------
 2 files changed, 5 insertions(+), 12 deletions(-)

--- linux-3.16-rc4.orig/Documentation/i2c/i2c-stub	2014-07-12 09:41:26.508195718 +0200
+++ linux-3.16-rc4/Documentation/i2c/i2c-stub	2014-07-12 10:40:05.064578130 +0200
@@ -20,9 +20,8 @@ operations.  This allows for continuous
 EEPROMs, among others.
 
 SMBus block commands must be written to configure an SMBus command for
-SMBus block operations. The first SMBus block write selects the block length.
-Subsequent writes can be partial. Block read commands always return
-the number of bytes selected with the first write.
+SMBus block operations. Writes can be partial. Block read commands always
+return the number of bytes selected with the largest write so far.
 
 The typical use-case is like this:
 	1. load this module
--- linux-3.16-rc4.orig/drivers/i2c/i2c-stub.c	2014-07-12 09:41:26.508195718 +0200
+++ linux-3.16-rc4/drivers/i2c/i2c-stub.c	2014-07-12 11:00:41.472813787 +0200
@@ -254,13 +254,6 @@ static s32 stub_xfer(struct i2c_adapter
 				ret = -EINVAL;
 				break;
 			}
-			if (b && len > b->len) {
-				dev_dbg(&adap->dev,
-					"Attempt to write more data (%d) than with initial SMBus block write (%d)\n",
-					len, b->len);
-				ret = -EINVAL;
-				break;
-			}
 			if (b == NULL) {
 				b = stub_find_block(&adap->dev, chip, command,
 						    true);
@@ -268,9 +261,10 @@ static s32 stub_xfer(struct i2c_adapter
 					ret = -ENOMEM;
 					break;
 				}
-				/* First write sets block length */
-				b->len = len;
 			}
+			/* Largest write sets read block length */
+			if (len > b->len)
+				b->len = len;
 			for (i = 0; i < len; i++)
 				b->block[i] = data->block[i + 1];
 			/* update for byte and word commands */

Would that work for you?

-- 
Jean Delvare
SUSE L3 Support
