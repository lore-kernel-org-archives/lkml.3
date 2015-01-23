Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbbAWON6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:13:58 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:40105 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbbAWONy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:13:54 -0500
Date: Fri, 23 Jan 2015 15:13:46 +0100
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] samples/bpf: Fix test_maps/bpf_get_next_key() test
Message-ID: <20150123151346.28ae0d6c@holzheu>
In-Reply-To: <CAADnVQ+3exrhp8bS50HEnMrYdg4i3+K7c6ewNZHRkBqtW-uwOA@mail.gmail.com>
References: <CAADnVQ+3exrhp8bS50HEnMrYdg4i3+K7c6ewNZHRkBqtW-uwOA@mail.gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012314-0029-0000-0000-00000313A69D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015 09:32:43 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Jan 22, 2015 at 8:01 AM, Michael Holzheu
> <holzheu@linux.vnet.ibm.com> wrote:
> > Looks like the "test_maps" test case expects to get the keys in
> > the wrong order when iterating over the elements:
> >
> > test_maps: samples/bpf/test_maps.c:79: test_hashmap_sanity: Assertion
> > `bpf_get_next_key(map_fd, &key, &next_key) == 0 && next_key == 2' failed.
> > Aborted
> >
> > Fix this and test for the correct order.
> 
> that will break this test on x86...
> we need to understand first why the order of two elements
> came out different on s390...
> Could it be that jhash() produced different hash for the same
> values on x86 vs s390 ?

Yes I think jhash() produces different results for input > 12 bytes
on big and little endian machines because of the following code
in include/linux/jhash.h:

        while (length > 12) {
                a += __get_unaligned_cpu32(k);
                b += __get_unaligned_cpu32(k + 4);
                c += __get_unaligned_cpu32(k + 8);
                __jhash_mix(a, b, c);
                length -= 12;
                k += 12;
        }

The contents of "k" is directly used as u32 and the result
of "__get_unaligned_cpu32(k)" is different for big and
little endian.

Michael

