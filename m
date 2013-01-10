Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab3AJTpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:45:11 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39394 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753911Ab3AJTpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:45:09 -0500
Message-ID: <1357847108.2894.10.camel@joe-AO722>
Subject: Re: checkpatch.pl error: Use of uninitialized value $max (line
 3407,3410)
From: Joe Perches <joe@perches.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 10 Jan 2013 11:45:08 -0800
In-Reply-To: <20130110191807.GA15621@roeck-us.net>
References: <20130110191807.GA15621@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-10 at 11:18 -0800, Guenter Roeck wrote:
> Hi all,

Hi Guenter.

> I get the following error when running checkpatch.pl:
> 
> scripts/checkpatch.pl -f drivers/hwmon/da9055-hwmon.c
> Use of uninitialized value $max in string eq at scripts/checkpatch.pl line 3407.
> Use of uninitialized value $max in pattern match (m//) at scripts/checkpatch.pl line 3410.

[]

> The checkpatch code creating the error was introduced with commit 4a273195
> (checkpatch: check usleep_range() arguments).

> Is this a but in checkpatch, or is something wrong in my environment ?

Yes, it's a checkpatch bug, ignore it for now.
You'd also get it if you had a memset.

It's a problem with the $Float test

I believe this should fix it.

I haven't tested it much though.

 scripts/checkpatch.pl | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9de3a69..3d0f577 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -230,12 +230,12 @@ our $Inline	= qr{inline|__always_inline|noinline};
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
-our $Float_hex	= qr{(?i:0x[0-9a-f]+p-?[0-9]+[fl]?)};
-our $Float_dec	= qr{(?i:((?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?))};
-our $Float_int	= qr{(?i:[0-9]+e-?[0-9]+[fl]?)};
+our $Float_hex	= qr{(?i)0x[0-9a-f]+p-?[0-9]+[fl]?};
+our $Float_dec	= qr{(?i)(?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?};
+our $Float_int	= qr{(?i)[0-9]+e-?[0-9]+[fl]?};
 our $Float	= qr{$Float_hex|$Float_dec|$Float_int};
-our $Constant	= qr{(?:$Float|(?i:(?:0x[0-9a-f]+|[0-9]+)[ul]*))};
-our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=)};
+our $Constant	= qr{$Float|(?i)(?:0x[0-9a-f]+|[0-9]+)[ul]*};
+our $Assignment	= qr{\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=};
 our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Operators	= qr{
 			<=|>=|==|!=|


