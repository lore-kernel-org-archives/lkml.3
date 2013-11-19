Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3KSB0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 20:26:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34932 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3KSB0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 20:26:49 -0500
Date: Tue, 19 Nov 2013 01:26:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Charley (Hao Chuan) Chu" <charley.chu@broadcom.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] FS: Fixed buffer overflow issue in seq_read()
Message-ID: <20131119012647.GB10323@ZenIV.linux.org.uk>
References: <FB8A4655DFD2B34DB16AE06DDDD6C0E21BDB93D2@SJEXCHMB12.corp.ad.broadcom.com>
 <CA+55aFyE=EDqMt1E94FSOFNEVWMS+mNVsJZYwiRmWfyB5HkykA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyE=EDqMt1E94FSOFNEVWMS+mNVsJZYwiRmWfyB5HkykA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 04:38:03PM -0800, Linus Torvalds wrote:
> Hmm.. Al - this looks like a major oversight, but it also looks like
> the wrong place to initialize count/from in, just because it doesn't
> follow any sane patterns.
> 
> My gut feel is that this needs more cleanup and some sane helper
> function that always initializes those fields when allocating a new
> buffer. Rather than the "initialize in random places and then miss a
> few".
> 
> Afaik, those fields currently get (re-)initialized when:
> 
>  - We do the memset() of the whole seq_file structure at seq_open() time.
> 
>  - at the top of traverse()
> 
>  - count (but not from) gets reinitialized when growing the buffer or
> after traverse() fails in seq_read()
> 
> and it really doesn't give me that happy fuzzy feeling of "that all
> makes sense". Charley's patch seems to fix a missing initialization,
> but I'd *really* like to have it all make more sense, and feel that
> we're not missing some *other* initialization.
> 
> Al?

See upthread.  The bug is real, but I would rather go for a different
fix; it's not worth helper functions, though - we have exactly two places
where free m->buf without freeing m itself, and all we need to do is
clearing m->count in those two places.  No point delaying that to the
next call of seq_read() (and no point cleaning m->from at all), as soon
as we free m->buf we obviously lose all the data that might've been in it.
