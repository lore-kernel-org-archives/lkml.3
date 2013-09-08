Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3IHPwP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 11:52:15 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:60731 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3IHPwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 11:52:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jL4ojFEWAkW0NDSERUFTQhPgwb6ToOcAsg_4QySex1GfA@mail.gmail.com>
References: <CAGXu5jJvuAC3paV5k_bmoHHrHVgc0Hi6ShSDk3iQUt1Lf0cioQ@mail.gmail.com>
	<20130908013210.GA30627@gondor.apana.org.au>
	<CAGXu5j+DoXK_9v430xhCzOO1bsuuhe84fjkf7+DZ0r35hUNBBg@mail.gmail.com>
	<20130908043703.GA31554@gondor.apana.org.au>
	<20130908045422.GA31896@gondor.apana.org.au>
	<CAGXu5jL4ojFEWAkW0NDSERUFTQhPgwb6ToOcAsg_4QySex1GfA@mail.gmail.com>
Date: Sun, 8 Sep 2013 08:52:11 -0700
X-Google-Sender-Auth: mwWDeabTW6aWL80PWMbLVVdF0ww
Message-ID: <CAGXu5jLQ8oex=PMftRsFcoB78SXSRM3LTVoib61agA392vSvTA@mail.gmail.com>
Subject: Re: race condition in crypto larval handling
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Tyler Hicks <tyhicks@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 7, 2013 at 11:01 PM, Kees Cook <keescook@chromium.org> wrote:
> On Sat, Sep 7, 2013 at 9:54 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Sun, Sep 08, 2013 at 02:37:03PM +1000, Herbert Xu wrote:
>>> On Sat, Sep 07, 2013 at 08:34:15PM -0700, Kees Cook wrote:
>>> >
>>> > However, I noticed on the "good" path (even without the above patch),
>>> > I sometimes see a double-kfree triggered by the modprobe process. I
>>> > can't, however, see how that's happening, since larval_destroy should
>>> > only be called when refcnt == 0.
>>>
>>> Do you still see this double free with this patch? Without the
>>> patch it is completely expected as killing the same lavral twice
>>> will cause memory corruption leading to all sorts of weirdness,
>>> even if you stop it from deleting the list entry twice.
>>
>> Actually I know what it is.  sha512 registers two algorithms.
>> Therefore, it will create two larvals in sequence and then destroy
>> them in turn.  So it's not a double free at all.  If you put a
>> printk in crypto_larval_alloc that should confirm this.
>
> Ah! That would make sense; it just happens to re-allocate to the exact
> same location, yes. Whew, that's certainly what's happening. I can
> retest to confirm in my morning.

Confirmed: 2 allocs happen, and then 2 kfrees. :)

-Kees

-- 
Kees Cook
Chrome OS Security
