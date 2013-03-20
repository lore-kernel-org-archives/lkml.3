Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab3CTQEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:04:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52280 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752090Ab3CTQEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:04:10 -0400
Message-ID: <1363795450.16270.33.camel@joe-AO722>
Subject: Re: [PATCH] Staging: comedi: serial2002: fixed consistent spacing
 issue
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Alice Ferrazzi <alice.ferrazzi@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 09:04:10 -0700
In-Reply-To: <20130320152951.GO21522@ZenIV.linux.org.uk>
References: <1363782411-11729-1-git-send-email-alice.ferrazzi@gmail.com>
	 <20130320124753.GZ9138@mwanda> <20130320152951.GO21522@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 15:29 +0000, Al Viro wrote:
> On Wed, Mar 20, 2013 at 03:47:53PM +0300, Dan Carpenter wrote:
> 
> > The original code here needs to broken up into functions so it isn't
> > squashed up against the 80 character limit.
> 
> I'd say what needs to be done to the original code...

All good things, thanks for taking the time to write it Al.
Not that I'm ever touching comedi code, but Hartley is, so
I'm adding him to cc just in case he didn't see it...

> Observation 1:
> if (foo) {
> 	A /* two lines */
> } else {
> 	B /* huge pile of shite */
> }
> return result;
> 
> is equivalent to
> 
> if (foo) {
> 	A
> 	return result;
> }
> B
> return result;
> 
> Observation 2:
> while (1) {
> 	A	/* a couple of lines */
> 	if (foo) {
> 		break;
> 	} else {
> 		B /* huge pile of shite */
> 	}
> }
> is equivalent to
> while (1) {
> 	A
> 	if (foo)
> 		break;
> 	B
> }
> 
> Observation 3:
> while (1) {
> 	A	/* moderate pile of shite, assigning foo */
> 	if (foo) {
> 		B /* huge pile of shite */
> 	}
> }
> is equivalent to
> while (1) {
> 	A
> 	if (!foo)
> 		continue;
> 	B
> }
> 
> Observation 4: functions are there for purpose.  When you have two identical
> piles of garbage (avert your eyes, or risk taking another look at your dinner)
> such as
> 				int unit, sign, min;
> 				unit =
> 				    (data.value >> 10) &
> 				    0x7;
> 				sign =
> 				    (data.value >> 13) &
> 				    0x1;
> 				min =
> 				    (data.value >> 14) &
> 				    0xfffff;
> 
> 				switch (unit) {
> 				case 0:{
> 						min =
> 						    min
> 						    *
> 						    1000000;
> 					}
> 					break;
> 				case 1:{
> 						min =
> 						    min
> 						    *
> 						    1000;
> 					}
> 					break;
> 				case 2:{
> 						min =
> 						    min
> 						    * 1;
> 					}
> 					break;
> 				}
> 				if (sign)
> 					min = -min;
> 
> you just might consider turning that pile of excrements into a helper
> function.  Incidentally, min = min * 1 is somewhat, er, pointless...
> 
> Observation 5:
> for (i = 0; i <= 4; i++) {
> {
> 	switch (i) {
> 	case 0: c = non_NULL_1; ... break;
> 	case 1: c = non_NULL_2; ... break;
> 	case 2: c = non_NULL_3; ... break;
> 	case 3: c = non_NULL_4; ... break;
> 	case 4: c = non_NULL_5; ... break;
> 	default: c = NULL; break;
> 	}
> 	if (c) {
> 		pile_of_shite
> 	}
> }
> might, perhaps, be taking defensive programming a bit too far...
> 
> Observation 6:
> the Vogon whose brain has produced that code up had been brought up on Pascal,
> Ada or something worse, and had been badly traumatized by semantics of switch
> and break.
> switch (foo) {
> 	case 0: {
> 		bar = baz;
> 	} break;
> 	case 1: {
> 	.....
> }
> is not quite conventional for C.
> 
> Observation 7: down, not across...


