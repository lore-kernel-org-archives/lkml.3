Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3A1N0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 08:26:33 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:49027 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab3A1N02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 08:26:28 -0500
MIME-Version: 1.0
In-Reply-To: <51065FD4.6090200@redhat.com>
References: <1359333506-13599-1-git-send-email-minchan@kernel.org>
	<CAOJsxLFg_5uhZsvPmVVC0nnsZLGpkJ0W6mHa=aavmguLGuTTnA@mail.gmail.com>
	<51065FD4.6090200@redhat.com>
Date: Mon, 28 Jan 2013 15:26:26 +0200
X-Google-Sender-Auth: ObL2enardKNEuJNEaq6xGimSyXk
Message-ID: <CAOJsxLG=3sWdFkvb++f2ywhs288ozoMXZd_g2WOAgxTqxayY_Q@mail.gmail.com>
Subject: Re: [RESEND PATCH v5 1/4] zram: Fix deadlock bug in partial write
From: Pekka Enberg <penberg@kernel.org>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 1:24 PM, Jerome Marchand <jmarchan@redhat.com> wrote:
> On 01/28/2013 08:16 AM, Pekka Enberg wrote:
>> On Mon, Jan 28, 2013 at 2:38 AM, Minchan Kim <minchan@kernel.org> wrote:
>>> Now zram allocates new page with GFP_KERNEL in zram I/O path
>>> if IO is partial. Unfortunately, It may cuase deadlock with
>>
>> s/cuase/cause/g
>>
>>> reclaim path so this patch solves the problem.
>>
>> It'd be nice to know about the problem in more detail. I'm also
>> curious on why you decided on GFP_ATOMIC for the read path and
>> GFP_NOIO in the write path.
>
> This is because we're holding a kmap_atomic page in the read path.

Okay, so that's about partial *reads* and not even mentioned in the
changelog, no?

AFAICT, you could rearrange the code in zram_bvec_read() as follows:

        if (is_partial_io(bvec))
                /* Use  a temporary buffer to decompress the page */
                uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
        else {
                uncmem = user_mem = kmap_atomic(page);
        }

and avoid the GFP_ATOMIC allocation.
