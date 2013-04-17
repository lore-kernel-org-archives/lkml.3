Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966084Ab3DQJpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:45:54 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35074 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753260Ab3DQJpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:45:52 -0400
X-Sasl-enc: W0QWL2rrdYobrIIQigUWvwVEZaV5GButr1LwHbi5Bhyq 1366191951
Message-ID: <516E6F4E.9030808@ladisch.de>
Date: Wed, 17 Apr 2013 11:45:50 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Device driver memory 'mmap()' function helper cleanup
References: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com> <201304171115.51509.arnd@arndb.de>
In-Reply-To: <201304171115.51509.arnd@arndb.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 17 April 2013, Linus Torvalds wrote:
>> Anyway, I'm attaching the untested patch to several drivers. Guys,
>> mind taking a look?
>
> I took a look at the hpet_mmap function, which still contains this check:
>
>         if (((vma->vm_end - vma->vm_start) != PAGE_SIZE) || vma->vm_pgoff)
>                 return -EINVAL;
>
> As far as I can tell, this check is implied by the new code in
> vm_iomap_memory as the len argument passed here is PAGE_SIZE, so you
> can remove another three lines in hpet_mmap.

Yes indeed.

> > [...] I just have this untested patch-collection for a few random
> > drivers (picked across a few different driver subsystems, just to make
> > it interesting).  I did that largely just to check the different use
> > cases, but I don't actually tend to *use* all that many fancy drivers,
> > so I don't have much of a way of testing it.

Any more-or-less recent x86 machine has HPET, so you could enable
CONFIG_HPET(_MMAP) and try the (completely untested) program below.


Regards,
Clemens

--8<---------------------------------------------------------------->8--

#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>

int main(void)
{
	int fd = open("/dev/hpet", O_RDONLY);
	if (fd == -1) {
		perror("/dev/hpet");
		return 1;
	}
	const volatile unsigned int *ptr = mmap(NULL, 4096, PROT_READ, MAP_SHARED, fd, 0);
	if (ptr == MAP_FAILED) {
		perror("mmap");
		return 1;
	}
	printf("frequency: %.5f MHz\n", 1e9 / ptr[1]);
	for (;;) {
		printf("\rcounter: %08x", ptr[60]);
		fflush(stdout);
		usleep(123456);
	}
}
