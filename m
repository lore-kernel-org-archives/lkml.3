Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab3BFO7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:59:15 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:53349 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab3BFO7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:59:10 -0500
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <CAOw_e7bgPLMzvTGczFH+npo+usrSOkHHRrpAGc-3GndVH0uuFw@mail.gmail.com>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	<CAOw_e7bgPLMzvTGczFH+npo+usrSOkHHRrpAGc-3GndVH0uuFw@mail.gmail.com>
Date: Wed, 6 Feb 2013 15:59:08 +0100
Message-ID: <CAJfpegvvF=u9mtZJwcdDZZD0Qwuw-dJSY-KpN2eT2Kw6fPfyZg@mail.gmail.com>
Subject: Re: [fuse-devel] [PATCH] fuse: make fuse daemon frozen along with
 kernel threads
From: Miklos Szeredi <miklos@szeredi.hu>
To: hanwen@xs4all.nl
Cc: Li Fei <fei.li@intel.com>, pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com,
        mingo@redhat.com, peterz@infradead.org, biao.wang@intel.com,
        linux-pm@vger.kernel.org, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 10:56 AM, Han-Wen Nienhuys <hanwenn@gmail.com> wrote:
> On Wed, Feb 6, 2013 at 2:11 AM, Li Fei <fei.li@intel.com> wrote:
>>
>> There is well known issue that freezing will fail in case that fuse
>> daemon is frozen firstly with some requests not handled, as the fuse
>> usage task is waiting for the response from fuse daemon and can't be
>> frozen.
>>
>> To solve the issue above, make fuse daemon frozen after all all user
>> space processes frozen and during the kernel threads frozen phase.
>> PF_FREEZE_DAEMON flag is added to indicate that the current thread is
>> the fuse daemon, set on connection, and clear on disconnection.
>> It works as all fuse requests are handled during user space processes
>> frozen, there will no further fuse request, and it's safe to continue
>> to freeze fuse daemon together with kernel freezable tasks.
>
> Will this work correctly if one FUSE daemon is opening files in from
> another FUSE filesystem?

As long as only non-fuse-daemon processes are generating the requests
(i.e. fuse daemons don't spontaneously generate new requests) it
should work.

I think more problematic is that userspace processes tend to
communicate with each other, sometimes in a non-trivial way.  For
example gethostbyname(3) will turn to nscd(8) for name service cache
results.  So a fuse daemon that might call gethostbyname() should mark
nscd with PF_FREEZE_DAEMON but that requires careful audit (or nscd
might mark itself PF_FREEZE_DAEMON for that reason).

And that's just an example of a most basic C library function.  There
are many more such hidden interactions that can trip up this scheme.

Thanks,
Miklos
