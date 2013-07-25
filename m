Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab3GYQvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:51:14 -0400
Received: from mx2.corp.phx1.mozilla.com ([63.245.216.70]:38420 "EHLO
	smtp.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab3GYQvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:51:11 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jul 2013 12:51:11 EDT
Message-ID: <51F1556A.20909@mozilla.com>
Date: Thu, 25 Jul 2013 09:42:18 -0700
From: Taras Glek <tglek@mozilla.com>
User-Agent: Postbox 3.0.8 (Windows/20130427)
MIME-Version: 1.0
To: Dhaval Giani <dgiani@mozilla.com>
CC: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
        linux-kernel@vger.kernel.org, tytso@mit.edu, vdjeric@mozilla.com,
        glandium@mozilla.com, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
References: <1374699833.7083.2.camel@localhost> <20130724233628.GD3641@logfs.org> <51F14136.30409@mozilla.com>
In-Reply-To: <51F14136.30409@mozilla.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dhaval Giani wrote:
> On 07/24/2013 07:36 PM, Jörn Engel wrote:
>> On Wed, 24 July 2013 17:03:53 -0400, Dhaval Giani wrote:
>>> I am posting this series early in its development phase to solicit some
>>> feedback.
>> At this state, a good description of the format would be nice.
>
> Sure. The format is quite simple. There is a 20 byte header followed 
> by an offset table giving us the offsets of 16k compressed zlib chunks 
> (The 16k is the default number, it can be changed with the use of szip 
> tool, the kernel should still decompress it as that data is in the 
> header). I am not tied to the format. I used it as that is what being 
> used here. My final goal is the have the filesystem agnostic of the 
> compression format as long as it is seekable.
>
>>
>>> We are implementing transparent decompression with a focus on ext4. One
>>> of the main usecases is that of Firefox on Android. Currently libxul.so
>>> is compressed and it is loaded into memory by a custom linker on
>>> demand. With the use of transparent decompression, we can make do
>>> without the custom linker. More details (i.e. code) about the linker 
>>> can
>>> be found at https://github.com/glandium/faulty.lib
>> It is not quite clear what you want to achieve here.
>
> To introduce transparent decompression. Let someone else do the 
> compression for us, and supply decompressed data on demand  (in this 
> case a read call). Reduces the complexity which would otherwise have 
> to be brought into the filesystem.
The main use for file compression for Firefox(it's useful on Linux 
desktop too) is to improve IO-throughput and reduce startup latency. In 
order for compression to be a net win an application should be aware of 
what is being compressed and what isn't. For example patterns for IO on 
large libraries (eg 30mb libxul.so) are well suited to compression, but 
SQLite databases are not.  Similarly for our disk cache: images should 
not be compressed, but javascript should be. Footprint wins are useful 
on android, but it's the increased IO throughput on crappy storage 
devices that makes this most attractive.

In addition of being aware of which files should be compressed, Firefox 
is aware of patterns of usage of various files it could schedule 
compression at the most optimal time.

Above needs tie in nicely with the simplification of not implementing 
compression at fs-level.
>
>>    One approach is
>> to create an empty file, chattr it to enable compression, then write
>> uncompressed data to it.  Nothing in userspace will ever know the file
>> is compressed, unless you explicitly call lsattr.
>>
>> If you want to follow some other approach where userspace has one
>> interface to write the compressed data to a file and some other
>> interface to read the file uncompressed, you are likely in a world of
>> pain.
> Why? If it is going to only be a few applications who know the file is 
> compressed, and read it to get decompressed data, why would it be 
> painful? What about introducing a new flag, O_COMPR which tells the 
> kernel, btw, we want this file to be decompressed if it can be. It can 
> fallback to O_RDONLY or something like that? That gets rid of the 
> chattr ugliness.
This transparent decompression idea is based on our experience with 
HFS+. Apple uses the fs-attribute approach. OSX is able to compress 
application libraries at installation-time, apps remain blissfully 
unaware but get an extra boost in startup perf.

So in Linux, the package manager could compress .so files, textual data 
files, etc.
>
>> Assuming you use the chattr approach, that pretty much comes down to
>> adding compression support to ext4.  There have been old patches for
>> ext2 around that never got merged.  Reading up on the problems
>> encountered by those patches might be instructive.
>
> Do you have subjects for these? When I googled for ext4 compression, I 
> found http://code.google.com/p/e4z/ which doesn't seem to exist, and 
> checking in my LKML archives gives too many false positives.
>
> Thanks!
> Dhaval
