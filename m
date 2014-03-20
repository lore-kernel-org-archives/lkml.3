Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744AbaCTUcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:32:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55437 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759024AbaCTUcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:32:13 -0400
Message-ID: <532B5017.2070400@zytor.com>
Date: Thu, 20 Mar 2014 13:31:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alejandra Morales <alejandra.morales@tum.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "christian@grothoff.org" <christian@grothoff.org>
Subject: Re: Cryogenic: Enabling Power-Aware Applications on Linux
References: <9E3F9C2076C45D4783F09B90D5BE77CE1AEF7A@BADWLRZ-SWMBX13.ads.mwn.de>
In-Reply-To: <9E3F9C2076C45D4783F09B90D5BE77CE1AEF7A@BADWLRZ-SWMBX13.ads.mwn.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 08:55 AM, Alejandra Morales wrote:
> 1) Open the character device corresponding to the active interface that is sending
> the packets, which we need to know beforehand.
> 2) Within the main loop, and before the transmission, calculate the delay and the
> timeout and pass it to Cryogenic by calling ioctl.
> 3) Call select before the transmission. The call to select will block until one of the
> events that are meant to allow the resumption of the task happen: an I/O operation
> requested by other applications or the expiration of the timeout that we set previously.
> 4) After the loop, close the file descriptor.
> 
> The resulting code looks like this:
> 
>  1 main()
>  2 {
>  3     sock_fd = create_socket();
>  4     fd = open("/dev/cryogenic/wlan0");
>  5     while() {
>  6         times = calculate_delay_timeout(period);
>  7         ioctl(fd, times);
>  8         select(fd);
>  9         send(sock_fd);
> 10     }
> 11     close(fd);
> 12     close(sock_fd);
> 13 }
> 
> The call to sleep() has been removed since it is assumed now that the delay and the
> timeout completely determine the transmission time. Nevertheless, this is just an
> example and programmers may still want to keep it depending on the behavior
> they want to achieve.

This looks quite interesting, but the API seems clumsy as hell.  It
would probably make more sense to simply make the timeout an fcntl() per
file descriptor.

> I would like to submit the module as a patch now, do you have any suggestions to
> do this properly? Also, I would really appreciate any feedback about the code, which
> you can find at the end of the e-mail. Thank you.

Please see Documentation/SubmittingPatches first.  Since this is a very
ambitious piece of work, expect to get some pushback.  This is NOT a
negative, but rather an indication that the work is valuable enough to
work with to integrate it into the kernel.  Most likely, in my opinion,
making this a standalone driver just isn't going to fly, but rather we
will want to integrate it into the core I/O model.

	-hpa

