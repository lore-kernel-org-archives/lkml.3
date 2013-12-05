Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab3LEEEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 23:04:46 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37162 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab3LEEEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 23:04:42 -0500
Message-ID: <529FFB57.9010505@gmail.com>
Date: Wed, 04 Dec 2013 21:04:39 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] perf trace fixes
References: <1386211302-31303-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1386211302-31303-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/4/13, 7:41 PM, David Ahern wrote:
> Hi Arnaldo:
>
> As I mentioned on IRC perf-trace fails on older kernels -- like RHEL6. This
> set of patches makes it at least usable - though still some problems I am
> hoping you can fix.
>
> Build perf with these patches and run:
>
>    perf trace -- dd if=/dev/zero of=/tmp/zero bs=4096 count=16
>
> you see something like this which is just wrong:
>
>    3.684 ( 0.007 ms): write(buf: 2, count: 140737077958816  ) = 27
>
> there is no fd (should be 1 for the write) and all the values are wrong.
> Perhaps it is an artifact of the older way of doing system call tracing, but
> I see something goofy with the 3.12 kernel as well:
>    5.633 ( 0.004 ms): write(fd: 2, buf: 0x7fff9177fee0, count: 24 ) = 24

forget this last comment about 3.12; it works fine. That write entry is 
the final write by dd:

write(2, "65536 bytes (66 kB) copied", 2665536 bytes (66 kB) copied) = 26

That one is fine and looking up I see the 4096 lines as expected.

For RHEL6, the problem is there for the 4096 lines:

32.641 ( 0.005 ms): read(buf: 0, count: 27258880) = 4096
32.655 ( 0.009 ms): write(buf: 1, count: 27258880) = 4096

buf and count are wrong. Adding -e write to the perf-trace I get:

33.775 ( 0.031 ms): write(buf: 1</tmp/zero>, count: 37437440) = 4096

which suggests an off-by-1 error with parsing syscalls versus 
raw_syscalls. I am hoping you have an idea on how to fix that.

David
