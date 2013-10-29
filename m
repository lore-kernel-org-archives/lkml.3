Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab3J2QYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:24:05 -0400
Received: from mx1.ait.ac.at ([62.218.164.131]:40714 "EHLO mx1.ait.ac.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255Ab3J2QYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:24:03 -0400
X-Greylist: delayed 768 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Oct 2013 12:24:03 EDT
From: Fiedler Roman <Roman.Fiedler@ait.ac.at>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Question regarding unexpected OOM kill on 3.8.0, swap stays
 untouched
Thread-Topic: Question regarding unexpected OOM kill on 3.8.0, swap stays
 untouched
Thread-Index: Ac7UwW4RCcE+41KXTUWfXnaFOAJAXw==
Date: Tue, 29 Oct 2013 16:11:12 +0000
Message-ID: <2ECE9D9EEF1F524185270138AE2326593BF8B0AA@S0MSMAIL112.arc.local>
Accept-Language: en-US, de-AT
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.180.51]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-29_06:2013-10-29,2013-10-29,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've seen quite a few OOM kills, which all followed a common pattern of swap depletion first. But today I get a reproducible one without major swap use.
 
Here is vmstat output while kill occurred:

# vmstat 3
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
2  0   8924  10352  18376 162232    0    0  1668    24  627 8948 69 26  0  5
 1  0   8924  11624  18848 161680    0    0  2476  1352  713 10533 68 26  0  7
 0  1   8924   4028  15948  55080    0    0 33487    24  725 5429 44 30  0 26       < last before kill
 1  0   8924 200392    616   5932   11    1 19433   465  331  752  2 11 72 15    < first after kill
 0  0   8924 200332    616   6004    0    0     0     0   66   11  0  0 100  0
 0  0   8924 200332    624   6004    0    0     0     4   65   11  0  0 98  2

Since swap should not be used so fast, that change in usage goes unnoticed, OOM seems to have happened while swap still available. According to e.g. [1], OOM kill should not happen then.

dmesg output:

[21745.390625] select 1 (init), adj 0, size 108, to kill
[21745.390632] select 1215 (bash), adj 0, size 198, to kill
[21745.390633] select 20178 (bash), adj 0, size 205, to kill
[21745.390634] select 25644 (fakeroot), adj 0, size 370, to kill
[21745.390636] select 25659 (rules), adj 0, size 550, to kill
[21745.390637] select 602 (make), adj 0, size 658, to kill
[21745.390638] select 2711 (bash), adj 0, size 799, to kill
[21745.390639] select 2712 (ld), adj 0, size 48287, to kill
[21745.390639] send sigkill to 2712 (ld), adj 0, size 48287   << the size is always quite similar, ranging 48000-52000, no matter how much swap is available.

Is there a known bug in the 3.8 series or am I missing something relevant? Could it be, that kernel is running short on special pages, but why should simple compiling of linux-kernel deplete those? Could it be, that swapping is to slow to cope with speed of new pages and this also triggers OOM and the cited kernel.org documentation is wrong? Apart from that, the machine is quite strange, it has 256MB RAM and 2.5GB swap and is usually not used for that kind of task. Since virtual swapdisk should be fast, I did not bother to change the VM-parameters just for a single compile run.

Roman

[1] https://www.kernel.org/doc/gorman/html/understand/understand016.html
