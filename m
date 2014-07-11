Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaGKRWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:22:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18288 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaGKRWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:22:36 -0400
Date: Fri, 11 Jul 2014 20:22:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        dcb314@hotmail.com
Subject: Re: [PATCH v3] drivers/staging/comedi/drivers/ni_atmio16d.c: remove
 pointless condition
Message-ID: <20140711172215.GV23001@mwanda>
References: <1405089127-21646-1-git-send-email-abbotti@mev.co.uk>
 <1405089510-23182-1-git-send-email-abbotti@mev.co.uk>
 <20140711153439.GD25880@mwanda>
 <53C0199C.6010008@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C0199C.6010008@mev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 06:06:36PM +0100, Ian Abbott wrote:
> On 2014-07-11 16:34, Dan Carpenter wrote:
> >On Fri, Jul 11, 2014 at 03:38:30PM +0100, Ian Abbott wrote:
> >>From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> >>
> >>From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> >>
> >>The issue was discovered with static analysis and has two instances in
> >>this file. The code looks like this
> >>if (x < 65536000) {
> >>	...
> >>} else if (x < 655360000) {
> >>	...
> >>} else if (x <= 0xffffffff /* 6553600000 */) {
> >>	...
> >>} else if (x <= 0xffffffff /* 65536000000 */) {
> >>	...
> >>}
> >>
> >>The meaning of this block is to select appropriate clock frequency for
> >>interval timer basing on "x", which is amount of time.
> >>
> >>Notes:
> >>1. That last condition matches previous one - that's the issue.
> >>2. Decimal numbers in comments don't match hex numbers in expressions.
> >>But in first case the numbers have same order, while in the second case
> >>the hex number is the same, and the decimal one is 10 times bigger.
> >>3. Actually type of "x" is "unsigned int", so its exact upper limit is
> >>not obviously known.
> >>4. There's no "else" block.
> >>
> >>So it makes sense to make an "else" block from last "else if" case. The
> >>code inside the block seems correct for such usage.
> >>
> >>[ Actually, get rid of the final "else if" case and change the
> >>next-to-last "else if" case to an "else" as the upper limit of "x" _is_
> >>known to be 0xffffffff (UINT_MAX), which is less than 6553600000 -- Ian ]
> >>
> >>Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79871
> >>Reported-by: David Binderman <dcb314@hotmail.com>
> >>Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> >>Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> >>---
> >>v2: Removed final "else if" block and changed preceding "else if" block
> >>to "else" block as the condition is always true due to limited range of
> >>"unsigned int". -- Ian
> >>v3: Corrected subject line I messed up in v2. -- Ian
> >>---
> >>  drivers/staging/comedi/drivers/ni_atmio16d.c | 10 ++--------
> >>  1 file changed, 2 insertions(+), 8 deletions(-)
> >>
> >>diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
> >>index 6ad27f5..b1b4744 100644
> >>--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
> >>+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
> >>@@ -335,12 +335,9 @@ static int atmio16d_ai_cmd(struct comedi_device *dev,
> >>  	} else if (cmd->convert_arg < 655360000) {
> >>  		base_clock = CLOCK_100_KHZ;
> >>  		timer = cmd->convert_arg / 10000;
> >>-	} else if (cmd->convert_arg <= 0xffffffff /* 6553600000 */) {
> >>+	} else /* cmd->convert_arg < 6553600000 */ {
> >
> >I think the comment is meant to be /* cmd->convert_arg >= 655360000 */
> >There is an extra zero on 6553600000.
> 
> That's not what I was intending to convey.  The preceding chain of
> if/else if was checking if cmd->convert_arg < 65536000, else if
> cmd->convert_arg < 655360000, and I was trying to convey that the
> final else part was valid for all remaining values less than
> 6553600000, which in fact is all remaining unsigned int values.
> (Obviously, I failed to convey this meaning to everyone!)


Oh.  I could have figured it out if I had looked at the context maybe
instead of just in the patch.  It's weird that we are saying
0x10000 x 1000 because we're mixing hex and decimal.

Anyway, ignore me...  I am a bad drive by reviewer.

regards,
dan carpenter

