Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab3BVQpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 11:45:31 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:34643 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921Ab3BVQp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 11:45:26 -0500
X-Authority-Analysis: v=2.0 cv=cYNQXw/M c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=Qsx_du5GiBkA:10 a=qvxnG7FKX0EA:10 a=XqmpcVLOK6kA:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=fxJcL_dCAAAA:8 a=7V-_XTfuMtAA:10 a=QfKxxUxMAAAA:8 a=tR1OGehjCua5FyPP3aoA:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.78.168.186
Message-ID: <5127A0A3.6040904@ubuntu.com>
Date: Fri, 22 Feb 2013 11:45:23 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Eric Wong <normalperson@yhbt.net>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fadvise: perform WILLNEED readahead in a workqueue
References: <20121215005448.GA7698@dcvr.yhbt.net> <20121216024520.GH9806@dastard>
In-Reply-To: <20121216024520.GH9806@dastard>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/15/2012 9:45 PM, Dave Chinner wrote:
> On Sat, Dec 15, 2012 at 12:54:48AM +0000, Eric Wong wrote:
>> Applications streaming large files may want to reduce disk
>> spinups and I/O latency by performing large amounts of readahead
>> up front. Applications also tend to read files soon after opening
>> them, so waiting on a slow fadvise may cause unpleasant latency
>> when the application starts reading the file.
>> 
>> As a userspace hacker, I'm sometimes tempted to create a
>> background thread in my app to run readahead().  However, I
>> believe doing this in the kernel will make life easier for other
>> userspace hackers.
>> 
>> Since fadvise makes no guarantees about when (or even if)
>> readahead is performed, this change should not hurt existing
>> applications.
>> 
>> "strace -T" timing on an uncached, one gigabyte file:
>> 
>> Before: fadvise64(3, 0, 0, POSIX_FADV_WILLNEED) = 0 <2.484832> 
>> After: fadvise64(3, 0, 0, POSIX_FADV_WILLNEED) = 0 <0.000061>
> 
> You've basically asked fadvise() to readahead the entire file if
> it can. That means it is likely to issue enough readahead to fill
> the IO queue, and that's where all the latency is coming from. If
> all you are trying to do is reduce the latency of the first read,
> then only readahead the initial range that you are going to need to
> read...

It shouldn't take 2 seconds to queue up some async reads.  Are you
using ext3?  The blocks have to be mapped in order to queue the reads,
and without ext4 extents, this means the indirect blocks have to be
read and can cause fadvise to block.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRJ6CjAAoJEJrBOlT6nu759s8IAKmIyZYDk1JSRP6oJaGaGZ/r
aZCBH52wTPH8DaqFGe+62L8lyIQ5hD15Y+zTuaWh+fJ7C1k/lU8F/QbKCG2D+xCB
vfLF0WRx63fWLLg8xZTRU1x8X6sG+Byp+UYWNspTDrL15ChlaqqGGmwLNo4JxLa8
+AGQVt1WMU3TitD9CUMUfYFWGUQsMR0gWeJkJnjHiEZ7VoGzft2PTlnvElzIk76u
3cmwfoKHrnXzi50rPtP2gonRjMwd8VY859qOk0zlHoMDMcXklAWeIN9PEUIMx+VP
fMnBm6u48cKXPYGvQrGMOdjxlt7k4LhGDZxIlvmwNHWUSaifmkJ8oBMvfbAYtUA=
=G5rE
-----END PGP SIGNATURE-----
