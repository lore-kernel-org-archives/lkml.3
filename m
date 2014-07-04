Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030243AbaGDNEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:04:32 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:42264 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965050AbaGDNE3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 4 Jul 2014 09:04:29 -0400
Message-Id: <53B6C1D70200007800020BE7@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Fri, 04 Jul 2014 14:01:43 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Greg KH" <gregkh@linuxfoundation.org>,
        "Don A. Bailey" <donb@securitymouse.com>
Cc: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] lz4: add overrun checks to
 lz4_uncompress_unknownoutputsize()
References: <20140703231103.GA4081@kroah.com> 
In-Reply-To: 
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.07.14 at 08:12, Jan Beulich wrote:
>>>> On 04.07.14 at 01:11, <gregkh@linuxfoundation.org> wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > Jan points out that I forgot to make the needed fixes to the
> > lz4_uncompress_unknownoutputsize() function to mirror the changes done
> > in lz4_decompress() with regards to potential pointer overflows.
> 
> Except that meanwhile Don agreed with my statement that neither
> this nor the two earlier patches really fix the issue. So rather than
> pushing this into 3.16 and stable trees, I wonder whether the two
> earlier ones shouldn't be reverted and then a clean and correct
> fix be applied.

So here's a patch which I think adds the missing pieces.

Jan

lz4: check for underruns

While overruns are already being taken care of, underruns (resulting
from overflows in the respective "op + length" (or similar) operations
weren't. Fix this, allowing commits 4a3a990451, 4148c1f67a, and
206204a116 to be reverted (perhaps apart from the return value
adjustments two of the three do).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
The patch applies correctly with or without said reverts carried out.

--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -89,6 +89,8 @@ static int lz4_uncompress(const char *so
 			ip += length;
 			break; /* EOF */
 		}
+		if (unlikely((unsigned long)cpy < (unsigned long)op))
+			goto _output_error;
 		LZ4_WILDCOPY(ip, op, cpy);
 		ip -= (op - cpy);
 		op = cpy;
@@ -147,6 +149,8 @@ static int lz4_uncompress(const char *so
 				goto _output_error;
 			continue;
 		}
+		if (unlikely((unsigned long)cpy < (unsigned long)op))
+			goto _output_error;
 		LZ4_SECURECOPY(ref, op, cpy);
 		op = cpy; /* correction */
 	}
@@ -209,6 +213,8 @@ static int lz4_uncompress_unknownoutputs
 			op += length;
 			break;/* Necessarily EOF, due to parsing restrictions */
 		}
+		if (unlikely((unsigned long)cpy < (unsigned long)op))
+			goto _output_error;
 		LZ4_WILDCOPY(ip, op, cpy);
 		ip -= (op - cpy);
 		op = cpy;
@@ -272,6 +278,8 @@ static int lz4_uncompress_unknownoutputs
 				goto _output_error;
 			continue;
 		}
+		if (unlikely((unsigned long)cpy < (unsigned long)op))
+			goto _output_error;
 		LZ4_SECURECOPY(ref, op, cpy);
 		op = cpy; /* correction */
 	}



