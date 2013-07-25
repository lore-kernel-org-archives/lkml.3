Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3GYPQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:16:11 -0400
Received: from mx2.corp.phx1.mozilla.com ([63.245.216.70]:55046 "EHLO
	smtp.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3GYPQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:16:09 -0400
Message-ID: <51F14136.30409@mozilla.com>
Date: Thu, 25 Jul 2013 11:16:06 -0400
From: Dhaval Giani <dgiani@mozilla.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: linux-kernel@vger.kernel.org, tytso@mit.edu, tglek@mozilla.com,
        vdjeric@mozilla.com, glandium@mozilla.com, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
References: <1374699833.7083.2.camel@localhost> <20130724233628.GD3641@logfs.org>
In-Reply-To: <20130724233628.GD3641@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 07:36 PM, Jörn Engel wrote:
> On Wed, 24 July 2013 17:03:53 -0400, Dhaval Giani wrote:
>> I am posting this series early in its development phase to solicit some
>> feedback.
> At this state, a good description of the format would be nice.

Sure. The format is quite simple. There is a 20 byte header followed by 
an offset table giving us the offsets of 16k compressed zlib chunks (The 
16k is the default number, it can be changed with the use of szip tool, 
the kernel should still decompress it as that data is in the header). I 
am not tied to the format. I used it as that is what being used here. My 
final goal is the have the filesystem agnostic of the compression format 
as long as it is seekable.

>
>> We are implementing transparent decompression with a focus on ext4. One
>> of the main usecases is that of Firefox on Android. Currently libxul.so
>> is compressed and it is loaded into memory by a custom linker on
>> demand. With the use of transparent decompression, we can make do
>> without the custom linker. More details (i.e. code) about the linker can
>> be found at https://github.com/glandium/faulty.lib
> It is not quite clear what you want to achieve here.

To introduce transparent decompression. Let someone else do the 
compression for us, and supply decompressed data on demand  (in this 
case a read call). Reduces the complexity which would otherwise have to 
be brought into the filesystem.

>    One approach is
> to create an empty file, chattr it to enable compression, then write
> uncompressed data to it.  Nothing in userspace will ever know the file
> is compressed, unless you explicitly call lsattr.
>
> If you want to follow some other approach where userspace has one
> interface to write the compressed data to a file and some other
> interface to read the file uncompressed, you are likely in a world of
> pain.
Why? If it is going to only be a few applications who know the file is 
compressed, and read it to get decompressed data, why would it be 
painful? What about introducing a new flag, O_COMPR which tells the 
kernel, btw, we want this file to be decompressed if it can be. It can 
fallback to O_RDONLY or something like that? That gets rid of the chattr 
ugliness.

> Assuming you use the chattr approach, that pretty much comes down to
> adding compression support to ext4.  There have been old patches for
> ext2 around that never got merged.  Reading up on the problems
> encountered by those patches might be instructive.

Do you have subjects for these? When I googled for ext4 compression, I 
found http://code.google.com/p/e4z/ which doesn't seem to exist, and 
checking in my LKML archives gives too many false positives.

Thanks!
Dhaval
