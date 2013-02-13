Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390Ab3BMReU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:34:20 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:55871 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760123Ab3BMReT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:34:19 -0500
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <CAJfpegvV0zQ5Lftx=ELP0MAH1-7oY5HfT-CSYEaFUWJLmXoD7A@mail.gmail.com>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	<2964781.rPUOipNRNb@vostro.rjw.lan>
	<CAJfpegtNUr+AJXZcKmLEGBYqu20DVFwzg-OvOk_nS3fBS3wd=Q@mail.gmail.com>
	<1660768.prnx6s70rD@vostro.rjw.lan>
	<CAJfpegt2B3n-QNK_W7O2H0JVfS=4jcUOzV_+w8ELPq19RJPewQ@mail.gmail.com>
	<20130212104608.GA24042@amd.pavel.ucw.cz>
	<CAJfpegvdVfEFTU5haMMi94PD1iZ1XyCRjg0O9vDjDg1yyaM-yA@mail.gmail.com>
	<CAJfpegvV0zQ5Lftx=ELP0MAH1-7oY5HfT-CSYEaFUWJLmXoD7A@mail.gmail.com>
Date: Wed, 13 Feb 2013 18:34:16 +0100
Message-ID: <CAJfpegsFThkzv3uF60AMXO7Y-yEzU_20HeGyPra0O8Vk5OqCGQ@mail.gmail.com>
Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel] [PATCH]
 fuse: make fuse daemon frozen along with kernel threads]
From: Miklos Szeredi <miklos@szeredi.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Goswin von Brederlow <goswin-v-b@web.de>, Li Fei <fei.li@intel.com>,
        len.brown@intel.com, mingo@redhat.com, peterz@infradead.org,
        biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 2:17 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Feb 12, 2013 at 2:13 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Tue, Feb 12, 2013 at 11:46 AM, Pavel Machek <pavel@ucw.cz> wrote:
>>
>>> (After all, with FUSE, filesystem clients are just doing IPC. In ideal
>>> world, that would be freezeable and killable with -9).

Well, I thought this can be constrained to locks directly related to
the fuse filesystem itself, but it can't...  The reason is page
faults.  Pretty much everyone and their brother uses get_user_pages*,
holding various locks (mmap_sem for sure but others as well).  A fuse
filesystem frozen during a page read will block those.

Separating those parts of the kernel that can be frozen from those
that can't looks increasingly difficult.

So I think the PF_FREEZE_DAEMON idea (the patch from Li Fei that
started this thread) may still be our best bet at handling this
situation.  The idea being that pure "originator" processes (ones that
take no part in serving filesystem syscalls) can be frozen up-front.
Then the "fuse daemon" (or "server") processes are hopefully in a
quiescent state and can be frozen without difficulty.

Unfortunately it needs help from userspace: the kernel can't easily
guess which processes are part of a "fuse daemon" and which aren't.
Fortunately we have a standard library (libfuse) that can tell it to
the kernel for the vast majority of cases.

Thanks,
Miklos
