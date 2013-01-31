Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab3AaXVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 18:21:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45732 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab3AaXVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 18:21:22 -0500
Message-ID: <510AFC6A.5030703@zytor.com>
Date: Thu, 31 Jan 2013 15:21:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jon Pry <jonpry@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: ABI violations eventually caused by short sighted coding style
References: <CA+3xLx6HRWuc58oWP=T1J9NkKx958DQEULy+gMt8mooj3nsw+g@mail.gmail.com>
In-Reply-To: <CA+3xLx6HRWuc58oWP=T1J9NkKx958DQEULy+gMt8mooj3nsw+g@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 02:20 PM, Jon Pry wrote:
> 
> I believe changes should be made to the coding style forcing developers to take
> action. There are a couple of solutions I can think of:
> 
> 1. 	Put the unions at the beginning of structures if possible, or at least put
> 	them in a position that would ensure 8 byte offset from the beginning of
> 	the struct. Such as after a u64. Multiple unions should ensure the data[]
> 	of the preceding unions to be a multiple of 8 bytes.
> 2.  Require the data element to be declared as u64[size/8].
> 3.  Pack the ioctl structures
> 
> My preference is for the former since it does not cause any
> unnecessary padding.
> 

"The former" doesn't work when you are talking about a choice of three
elements.

packed structures are *very* expensive to use on some architectures, so
that is not a good solution.

In many, if not most cases, this is actually better handled by having
different ioctl numbers for each version/interface, but if you have to
make it self-contained, it makes most sense to make the common portion a
u64 or explicitly align the union to u64.

Another thing to keep in mind is that it often makes a lot more sense to
have a length member, and skip the problematic union.  That way a future
version of the kernel can simply memset() the part of the structure that
isn't initialized, and doesn't need a huge apparatus to keep track of
each individual version.

	-hpa



