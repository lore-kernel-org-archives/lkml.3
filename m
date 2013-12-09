Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386Ab3LIDRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 22:17:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760259Ab3LIDRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 22:17:35 -0500
Message-ID: <1386559014.4875.16.camel@marge.simpson.net>
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
From: Mike Galbraith <bitbucket@online.de>
To: Len Brown <lenb@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Date: Mon, 09 Dec 2013 04:16:54 +0100
In-Reply-To: <CAJvTdKn_2mihtMLiQVNCOp_zokx8CsSr2c5NhbkbfJ-qvma-8Q@mail.gmail.com>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
	 <1386478624.4748.19.camel@marge.simpson.net>
	 <CAJvTdKn_2mihtMLiQVNCOp_zokx8CsSr2c5NhbkbfJ-qvma-8Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:UZBFkE6PjThfhO7lxAuLsOwRnFGv9S9qV4FoUgfurvH
 n2oM9VvNgflmvwHiL3C2faaRSXBc4fEGdQDhJl7nj9icNz+k1g
 rAy7ZV6R0FkICOL4M/2Zn3Jm469omu/EooCdzhCPj+PFNnDVwV
 7vhNeEOJYAXxK+G/cYKSkq7E9XKhVRdvCbiZWYdcNoOzFYk/yc
 02qpRM1raXEqHjndF5pF0kmTvoc7c+VqWh/Cn0KV1J5OfHbRpJ
 kyIUuXdnxFgQBv6DYJqn1scAyVfba9/RmCFdxpxZQ28H+Jk+yl
 1tnlWNKF4hNZGcjI3tf3SFj1Dr68W8EIYGYvaS/lAtq6sMgNKV
 1y7qsj8G6N8fDr4T8nQPUDzHxt2lfD3VwPm1LJbdJJuU32cjpb
 vk6P0Eif+UA1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-08 at 15:40 -0500, Len Brown wrote: 
> > FWIW, my little x3550 (E5620) box is spending ~99% of its time in C3 per
> > powertop, deepest state it has.
> 
> Please run turbostat, which always describes what the hardware does.
> Depending on the version of powertop and the hardware involved,
> it may be describing that the OS requested -- which is not always the same.
> 
> The hardware reserves the right to demote any requested C-state to a
> shallower one.  Also, it is the hardware decision whether to promote
> core c-states requested by the OS into power saving package C-states.

Hrm, turbostat says rtbox has a C6, and is using it.  Ah, BIOS says ACPI
C3 == Intel C6, so I suppose Intel C3 == ACPI C2.  Whatever, both tools
seem to agree that these particular boxen (x3550/E5620 and DL980/X7560)
are snoozing peacefully.

rtbox:~ # turbostat -i 60
cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6 CTMP   %pc3   %pc6
          0.18 1.73 2.40   0   0.19   0.02  99.61   25   0.08  92.74
  0   0   0.47 1.60 2.40   0   0.62   0.08  98.83   18   0.08  92.74
  1   1   0.03 1.61 2.40   0   0.05   0.00  99.92   25
  9   2   0.05 1.73 2.40   0   0.06   0.00  99.89   16
 10   3   0.15 2.13 2.40   0   0.05   0.01  99.79   20

vogelweide:~/:[0]# turbostat -i 60
pk cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6 CTMP   %pc3   %pc6
             0.06 2.03 2.26   0   0.76  99.18   0.00   49  94.97   0.00
 0   0   0   0.40 1.57 2.26   3  25.28  74.32   0.00   49  64.24   0.00
 0   1   1   0.08 2.16 2.26   3  19.28  80.64   0.00   48
 0   2   2   0.09 2.20 2.26   3   0.00  99.91   0.00   49
 0   3   3   0.09 2.20 2.26   3   0.00  99.91   0.00   49
 0   8   4   0.08 2.21 2.26   3   0.00  99.91   0.00   45
 0   9   5   0.08 2.22 2.26   3   0.00  99.92   0.00   46
 0  10   6   0.08 2.23 2.26   3   0.00  99.92   0.00   45
 0  11   7   0.08 2.23 2.26   3   0.00  99.92   0.00   45
 1   0   8   0.10 1.94 2.26   3   0.01  99.89   0.00   38  99.88   0.00
 1   1   9   0.08 2.11 2.26   3   0.00  99.92   0.00   39
 1   2  10   0.08 2.12 2.26   3   0.00  99.92   0.00   41
 1   3  11   0.07 2.14 2.26   3   0.00  99.92   0.00   41
 1   8  12   0.08 2.15 2.26   3   0.00  99.92   0.00   42
 1   9  13   0.07 2.17 2.26   3   0.00  99.92   0.00   43
 1  10  14   0.07 2.19 2.26   3   0.00  99.92   0.00   41
 1  11  15   0.07 2.20 2.26   3   0.00  99.93   0.00   41
 2   0  16   0.09 1.93 2.26   3   0.01  99.90   0.00   41  99.89   0.00
 2   1  17   0.07 2.09 2.26   3   0.00  99.92   0.00   40
 2   2  18   0.07 2.11 2.26   3   0.00  99.93   0.00   41
 2   3  19   0.07 2.12 2.26   3   0.00  99.93   0.00   42
 2   8  20   0.07 2.14 2.26   3   0.00  99.93   0.00   41
 2   9  21   0.07 2.16 2.26   3   0.00  99.93   0.00   41
 2  10  22   0.07 2.17 2.26   3   0.00  99.93   0.00   37
 2  11  23   0.07 2.20 2.26   3   0.00  99.93   0.00   39
 3   0  24   0.08 1.91 2.26   3   0.01  99.91   0.00   41  99.88   0.00
 3   1  25   0.06 2.07 2.26   3   0.00  99.93   0.00   42
 3   2  26   0.07 2.09 2.26   3   0.02  99.92   0.00   41
 3   3  27   0.06 2.11 2.26   3   0.00  99.94   0.00   42
 3   8  28   0.06 2.12 2.26   3   0.00  99.94   0.00   47
 3   9  29   0.06 2.15 2.26   3   0.00  99.94   0.00   46
 3  10  30   0.06 2.18 2.26   3   0.00  99.94   0.00   44
 3  11  31   0.06 2.19 2.26   3   0.02  99.92   0.00   46
 4   0  32   0.07 1.92 2.26   3   0.01  99.92   0.00   36  96.25   0.00
 4   1  33   0.06 2.07 2.26   3   0.00  99.94   0.00   36
 4   2  34   0.06 2.08 2.26   3   0.00  99.94   0.00   39
 4   3  35   0.05 2.11 2.26   3   0.00  99.94   0.00   39
 4   8  36   0.05 2.12 2.26   3   3.67  96.28   0.00   40
 4   9  37   0.05 2.15 2.26   3   0.00  99.94   0.00   42
 4  10  38   0.05 2.18 2.26   3   0.00  99.95   0.00   39
 4  11  39   0.05 2.20 2.26   3   0.00  99.95   0.00   40
 5   0  40   0.07 1.73 2.26   3   0.02  99.91   0.00   35  99.90   0.00
 5   1  41   0.05 2.00 2.26   3   0.00  99.95   0.00   36
 5   2  42   0.05 2.04 2.26   3   0.00  99.95   0.00   39
 5   3  43   0.04 2.04 2.26   3   0.00  99.95   0.00   38
 5   8  44   0.05 2.09 2.26   3   0.00  99.95   0.00   40
 5   9  45   0.04 2.10 2.26   3   0.00  99.95   0.00   41
 5  10  46   0.04 2.13 2.26   3   0.00  99.96   0.00   37
 5  11  47   0.04 2.17 2.26   3   0.00  99.96   0.00   37
 6   0  48   0.08 1.61 2.26   3   0.02  99.90   0.00   35  99.87   0.00
 6   1  49   0.05 1.79 2.26   3   0.01  99.94   0.00   36
 6   2  50   0.04 1.98 2.26   3   0.00  99.96   0.00   36
 6   3  51   0.04 2.00 2.26   3   0.00  99.96   0.00   37
 6   8  52   0.04 2.01 2.26   3   0.00  99.96   0.00   38
 6   9  53   0.03 2.07 2.26   3   0.00  99.96   0.00   36
 6  10  54   0.03 2.08 2.26   3   0.00  99.96   0.00   36
 6  11  55   0.03 2.14 2.26   3   0.00  99.96   0.00   36
 7   0  56   0.05 1.69 2.26   3   0.01  99.94   0.00   41  99.89   0.00
 7   1  57   0.03 1.87 2.26   3   0.00  99.97   0.00   41
 7   2  58   0.03 1.89 2.26   3   0.00  99.97   0.00   44
 7   3  59   0.03 1.93 2.26   3   0.00  99.97   0.00   44
 7   8  60   0.03 1.97 2.26   3   0.05  99.92   0.00   41
 7   9  61   0.03 2.02 2.26   3   0.00  99.97   0.00   38
 7  10  62   0.02 2.06 2.26   3   0.00  99.97   0.00   39
 7  11  63   0.03 2.12 2.26   3   0.00  99.97   0.00   36

