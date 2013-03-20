Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab3CTPaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:30:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41327 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531Ab3CTP36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:29:58 -0400
Date: Wed, 20 Mar 2013 15:29:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alice Ferrazzi <alice.ferrazzi@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: serial2002: fixed consistent spacing
 issue
Message-ID: <20130320152951.GO21522@ZenIV.linux.org.uk>
References: <1363782411-11729-1-git-send-email-alice.ferrazzi@gmail.com>
 <20130320124753.GZ9138@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130320124753.GZ9138@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 03:47:53PM +0300, Dan Carpenter wrote:

> The original code here needs to broken up into functions so it isn't
> squashed up against the 80 character limit.

I'd say what needs to be done to the original code...

Observation 1:
if (foo) {
	A /* two lines */
} else {
	B /* huge pile of shite */
}
return result;

is equivalent to

if (foo) {
	A
	return result;
}
B
return result;

Observation 2:
while (1) {
	A	/* a couple of lines */
	if (foo) {
		break;
	} else {
		B /* huge pile of shite */
	}
}
is equivalent to
while (1) {
	A
	if (foo)
		break;
	B
}

Observation 3:
while (1) {
	A	/* moderate pile of shite, assigning foo */
	if (foo) {
		B /* huge pile of shite */
	}
}
is equivalent to
while (1) {
	A
	if (!foo)
		continue;
	B
}

Observation 4: functions are there for purpose.  When you have two identical
piles of garbage (avert your eyes, or risk taking another look at your dinner)
such as
				int unit, sign, min;
				unit =
				    (data.value >> 10) &
				    0x7;
				sign =
				    (data.value >> 13) &
				    0x1;
				min =
				    (data.value >> 14) &
				    0xfffff;

				switch (unit) {
				case 0:{
						min =
						    min
						    *
						    1000000;
					}
					break;
				case 1:{
						min =
						    min
						    *
						    1000;
					}
					break;
				case 2:{
						min =
						    min
						    * 1;
					}
					break;
				}
				if (sign)
					min = -min;

you just might consider turning that pile of excrements into a helper
function.  Incidentally, min = min * 1 is somewhat, er, pointless...

Observation 5:
for (i = 0; i <= 4; i++) {
{
	switch (i) {
	case 0: c = non_NULL_1; ... break;
	case 1: c = non_NULL_2; ... break;
	case 2: c = non_NULL_3; ... break;
	case 3: c = non_NULL_4; ... break;
	case 4: c = non_NULL_5; ... break;
	default: c = NULL; break;
	}
	if (c) {
		pile_of_shite
	}
}
might, perhaps, be taking defensive programming a bit too far...

Observation 6:
the Vogon whose brain has produced that code up had been brought up on Pascal,
Ada or something worse, and had been badly traumatized by semantics of switch
and break.
switch (foo) {
	case 0: {
		bar = baz;
	} break;
	case 1: {
	.....
}
is not quite conventional for C.

Observation 7: down, not across...
