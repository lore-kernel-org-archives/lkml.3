Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaCLAOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 20:14:30 -0400
Received: from mdfmta010.mxout.tbr.inty.net ([91.221.168.51]:49212 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755722AbaCLAO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 20:14:29 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Mar 2014 20:14:28 EDT
Message-ID: <531FA54F.5020109@lougher.demon.co.uk>
Date: Wed, 12 Mar 2014 00:07:43 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Lasse Collin <lasse.collin@tukaani.org>
CC: Phillip Lougher <phillip@lougher.demon.co.uk>,
        Kyle McMartin <kyle@infradead.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] xz: make XZ_DEC_BCJ filters non-optional
References: <20140228230017.GE14970@merlin.infradead.org> <20140303145137.70819698@tukaani.org> <CAGVrzcZ7KU-m9s9KgoigK+WdSqeqwEmm=_pY6qF=ep2vFp6WUg@mail.gmail.com> <20140304202038.03b36109@tukaani.org> <53169123.4020909@lougher.demon.co.uk> <20140305182422.767a6cbe@tukaani.org>
In-Reply-To: <20140305182422.767a6cbe@tukaani.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MDF-HostID: 9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/14 16:24, Lasse Collin wrote:
> On 2014-03-05 Phillip Lougher wrote:
>> (BTW Kyle you should have CC'd me on the patch as a courtesy).
>
> I could have done that too but somehow I didn't, sorry.

np

>
>> But speaking as the Squashfs author, the lack of BCJ support for
>> an architecture creates a subtle failure mode in Squashfs, this is
>> because not all blocks in a Squashfs filesystem get compressed
>> with a BCJ filter.  At compression time each block is compressed
>> without any BCJ filter, and then with the BCJ filter(s) selected on
>> the command line, and the best compression for *that* block is
>> chosen.  What this means is kernels without a particular
>> BCJ filter can still read the Squashfs metadata (mount, ls etc.) and
>> read many of the files, it is only some files that mysteriously
>> fail with decompression error.  As such this will be (and has been)
>> invariably treated as a bug in Squashfs.
>
> There is an easy way to make Squashfs give an error message in the
> kernel log. xz_dec_run() gives XZ_OPTIONS_ERROR when valid-looking but
> unsupported input is detected. Currently Squashfs treats all error
> codes from xz_dec_run() the same way so the reason for the
> decompression error is silently lost.

Yes, that is deliberate.  It's to give a generic easy to understand
error message for potentially novice users that may be running
Linux from LiveCDs.

When I wrote the original zlib support for Squashfs, I put in a lot
of debug information in the zlib error messages, e.g.

                        ERROR("zlib_inflate returned unexpected result"
                                " 0x%x, srclength %d, avail_in %d,"
                                " avail_out %d\n", zlib_err, srclength,
                                msblk->stream.avail_in,
                                msblk->stream.avail_out);

But after mainlining Squashfs in 2009, I started to get increasing
complaints that the error messages were too technical (full of
hex numbers) and confusing to new users - the kind of people who
maybe burn a corrupt liveCD and then get screenfulls of these
errors full of different numbers coming up on the screen.  They
would do a websearch and discover that the errors meant
"corrupted disk", and then ask why didn't it just say that, and
not give all those numbers.  Or worse they'd just silently give up
and go back to Windows.

So in March 2009 I changed it to the error message

ERROR("zlib_inflate error, data probably corrupt\n")

With *no* numbers ... and I copied the same approach for xz.

In kernel 3.13 (released earlier this year) I went further and
pulled out the error message printing from the compression
wrappers, and made it a single generic message, because I
realised there was no longer any decompressor specific error
handling (just the same message in each wrapper).

ERROR("%s decompression failed, data probably corrupt\n",
                         msblk->decompressor->name);

Putting back separate error messages into each decompressor wrapper,
and then putting back different error messages based on the
error code return seems like a retrograde step because distros don't
like them.

>
> Below is an *untested* fix. I'm not sure about the exact wording of the
> error message, so feel free to improve it.
>
> diff -Narup linux-3.14-rc5.orig/fs/squashfs/xz_wrapper.c linux-3.14-rc5/fs/squashfs/xz_wrapper.c
> --- linux-3.14-rc5.orig/fs/squashfs/xz_wrapper.c	2014-03-03 04:56:16.000000000 +0200
> +++ linux-3.14-rc5/fs/squashfs/xz_wrapper.c	2014-03-05 18:08:58.729643127 +0200
> @@ -170,8 +170,13 @@ static int squashfs_xz_uncompress(struct
>
>   	squashfs_finish_page(output);
>
> -	if (xz_err != XZ_STREAM_END || k < b)
> +	if (xz_err != XZ_STREAM_END || k < b) {
> +		if (xz_err == XZ_OPTIONS_ERROR)
> +			ERROR("Unsupported XZ-compressed data; check the XZ "
> +					"options in the kernel config\n");
> +
>   		goto out;
> +	}
>
>   	return total + stream->buf.out_pos;
>
>
>> Moreover, without expert knowledge of Squashfs, and the config
>> options, most people will not have a clue how to fix the issue.
>>
>> This is why I prefer the first option, which is to reinstate
>> the enabling of all filters by default, and then to allow people
>> to remove the filters they don't want.
>
> I will submit the first option. In the other email Florian Fainelli
> seemed to be OK with that too.
>
>> BTW there is a potential additional fix for Squashfs that will
>> make its handling of (lack of) BCJ filters more intelligent
>> at mount time, but this of course only addresses Squashfs,
>> and it relies on an additional call into XZ being added.  The
>> BCJ filters specified at filesystem creation are stored in the
>> compression options part of the superblock, and are known at
>> mount time.  Squashfs should check that these filters are
>> supported by the kernel and refuse to mount it otherwise.  This
>> has not been done because AFAIK there is no way to query XZ to
>> determine which BCJ filters are supported (beyond passing it a
>> test stream which is too messy).
>
> You can use #ifdef CONFIG_XZ_DEC_X86 and such, although maybe that's
> not convenient enough.

Yes, I will try using the XZ config definitions directly in
Squashfs.

Thanks

Phillip


