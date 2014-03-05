Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbaCEDFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:05:07 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:44749 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbaCEDFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:05:03 -0500
MIME-Version: 1.0
In-Reply-To: <53156621.60900@cn.fujitsu.com>
References: <1393497616-16428-1-git-send-email-tangchen@cn.fujitsu.com>
 <1393497616-16428-3-git-send-email-tangchen@cn.fujitsu.com>
 <530F2A2D.50307@jp.fujitsu.com> <530F3327.8020205@jp.fujitsu.com> <53156621.60900@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 4 Mar 2014 22:04:42 -0500
Message-ID: <CAHGf_=prxk+gJt8Xk_aZdVRcMLifw7jMYNfMb-h34FOEFuUO4g@mail.gmail.com>
Subject: Re: [Update PATCH 2/2] aio, mem-hotplug: Add memory barrier to aio
 ring page migration.
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, Benjamin LaHaise <bcrl@kvack.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jeff Moyer <jmoyer@redhat.com>,
        guz.fnst@cn.fujitsu.com,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +             /*
>> +              * Ensure that the page's data was copied from old one by
>> +              * aio_migratepage().
>> +              */
>> +             smp_rmb();
>> +
>
> smp_read_barrier_depends() is better.
>
> "One could place an A smp_rmb() primitive between the pointer fetch and
>  dereference. However, this imposes unneeded overhead on systems (such as
>  i386, IA64, PPC, and SPARC) that respect data dependencies on the read side.
>  A smp_read_barrier_depends() primitive has been added to the Linux 2.6 kernel
>  to eliminate overhead on these systems."
>                 -- From Chapter 7.1 of <Memory Barriers: a Hardware View for Software Hackers>
>                    Written by Paul E. McKenney
>

Right.
The document of memory barrier described this situation.


see https://www.kernel.org/doc/Documentation/memory-barriers.txt

CPU 1                            CPU 2
===============      ===============
{ M[0] == 1, M[1] == 2, M[3] = 3, P == 0, Q == 3 }
M[1] = 4;
<write barrier>
ACCESS_ONCE(P) = 1
                                     Q = ACCESS_ONCE(P);
                                     <data dependency barrier>
                                     D = M[Q];
