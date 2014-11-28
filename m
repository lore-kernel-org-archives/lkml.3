Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaK1XCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 18:02:49 -0500
Received: from smtp1-out.insa-rennes.fr ([193.52.94.24]:3072 "EHLO
	smtp1-out.insa-rennes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaK1XCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 18:02:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqwEALn+eFQKBQEl/2dsb2JhbABbg1dYxw6GTgKBIAEBAQEBfYQDAQEEJ1EBEAsYCRYPCQMCAQIBDzYGDQEFAgEBBYgiAx/MBg2GAgEBAQEBAQEDAQEBAQEBARuOQ4FXCiQzB4RIBZpGgy+GJDeEJoJGgkyHfiVJAYEEgUIBAQE
Message-ID: <5478FF09.6090508@supelec.fr>
Date: Sat, 29 Nov 2014 00:02:33 +0100
From: Laurent Georget <laurent.georget@supelec.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2] adjtimex.2: add explanation about ADJ_TAI action
References: <54787B5C.1080802@supelec.fr> <20141128210043.GB14432@localhost.localdomain>
In-Reply-To: <20141128210043.GB14432@localhost.localdomain>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 28/11/2014 22:00, Richard Cochran a écrit :
> On Fri, Nov 28, 2014 at 02:40:44PM +0100, Laurent Georget wrote:
>> @@ -101,7 +99,19 @@ combination of zero or more of the following bits:
>>  Ordinary users are restricted to a zero value for
>>  .IR modes .
>>  Only the superuser may set any parameters.
>> +.PP
>> +Support for TAI (Atomic International Time, for a complete explanation
>> about
>> +what it is and what is the difference between TAI and UTC, see
>> +.UR http://www.bipm.org/en/bipm/tai/tai.html
>> +.I BIPM
>> +.UE )
>> +has been added in version 2.6.29. For any clock, the TAI offset may
> 
> Not for "any clock", just for CLOCK_REALTIME.

Considering that this is the only one representing the "human" time and
supporting an adjtime action, indeed, it's not relevant for anything
else than the realtime clock.

> 
>> +be calculated by adding a value to the UTC offset which is updated when a
>> +leap second is added or deleted.
>>  .br
>> +All the offsets in the timex structure are expressed between the value
>> of the
>> +clock and the corresponding value (e.g. TAI offset is the difference
>> between
>> +the clock and the TAI, not between TAI and another value such as UTC).
> 
> The TAI offset is just (TAI - UTC). That's all.
> 

Yes, my mistake, I misunderstood the part about timekeeping
(__timekeeping_set_tai_offset() in kernel/time/timekeeping.c, line 815)
which does store the offset in several formats (monotonic -> TAI and UTC
-> TAI). But this is not directly related to the timex value. Aniway
this is not very relevant in the man page.

Thank you for your comments. Below is a new version of the patch. Less
unrelevant chit-chat, more useful information (hopefully).


diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
index 20a2f0b..871e607 100644
--- a/man2/adjtimex.2
+++ b/man2/adjtimex.2
@@ -26,9 +26,6 @@
 .\" Modified 2004-05-27 by Michael Kerrisk <mtk.manpages@gmail.com>
 .\" Modified 2014-11-28 by Laurent Georget <laurent.georget@supelec.fr>
 .\"
-.\" FIXME Document ADJ_TAI (added in Linux 2.6.26)
-.\"		commit 153b5d054ac2d98ea0d86504884326b6777f683d
-.\"
 .\" FIXME Document ADJ_MICRO and ADJ_NANO (added in Linux 2.6.26)
 .\"		commit eea83d896e318bda54be2d2770d2c5d6668d11db
 .\"		Author: Roman Zippel <zippel@linux-m68k.org>
@@ -74,6 +71,17 @@ struct timex {
                             (read-only) */
     struct timeval time; /* current time (read-only) */
     long tick;           /* usecs between clock ticks */
+
+    long ppsfreq;        /* pps frequency (scaled ppm) (read-only) */
+    long jitter;         /* pps jitter (usec) (read-only) */
+    int shift;           /* interval duration (sec) (read-only) */
+    long stabil;         /* pps stability (scaled ppm) (read-only) */
+    long jitcnt;         /* jitter limit exceeded (read-only) */
+    long calcnt;         /* calibration intervals (read-only) */
+    long errcnt;         /* calibration errors (read-only) */
+    long stbcnt;         /* stability limit exceeded (read-only) */
+
+    int tai;             /* TAI offset (s) (read-only) */
 };
 .fi
 .in
@@ -93,6 +101,7 @@ combination of zero or more of the following bits:
 #define ADJ_ESTERROR          0x0008 /* estimated time error */
 #define ADJ_STATUS            0x0010 /* clock status */
 #define ADJ_TIMECONST         0x0020 /* pll time constant */
+#define ADJ_TAI               0x0080 /* TAI offset */
 #define ADJ_TICK              0x4000 /* tick value */
 #define ADJ_OFFSET_SINGLESHOT 0x8001 /* old-fashioned adjtime() */
 .fi
@@ -102,6 +111,20 @@ Ordinary users are restricted to a zero value for
 .IR modes .
 Only the superuser may set any parameters.
 .br
+In the case of
+.BR ADJ_TAI ,
+as
+.I buf->tai
+is read-only, the new value is passed through
+.IR buf->constant .
+.PP
+Support for TAI (Atomic International Time, for a complete explanation
about
+what it is and what is the difference between TAI and UTC, see
+.UR http://www.bipm.org/en/bipm/tai/tai.html
+.I BIPM
+.UE )
+has been added in version 2.6.29.
+.br
 .ne 12v
 .SH RETURN VALUE
 On success,
