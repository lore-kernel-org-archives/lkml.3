Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab3JXMGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:06:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab3JXMGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:06:14 -0400
Message-ID: <52690D1E.6060400@redhat.com>
Date: Thu, 24 Oct 2013 08:05:50 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Ming Lei <ming.lei@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Andreas Herrmann <herrmann.der.user@googlemail.com>,
        tigran@aivazian.fsnet.co.uk
Subject: Re: [PATCH 1/2] firmware, fix request_firmware_nowait() freeze with
 no uevent
References: <1382304926-1641-1-git-send-email-prarit@redhat.com> <1382304926-1641-2-git-send-email-prarit@redhat.com> <CACVXFVO_bbYsRRgZ+MfVKf5=VRNy=O3VUg0mh2fumEi7cObuiw@mail.gmail.com> <5265A9A4.2000100@redhat.com> <CACVXFVM7eKA2m+ten5-1EYNdJkc5SuZy2cimpH9j94OOdsb9Uw@mail.gmail.com> <526706FC.2070105@redhat.com> <CACVXFVMmp3gOpfEtjQ-fO62=RY+7_ZJ11UW89GXDPNKE61+keg@mail.gmail.com> <5267A6CA.1000505@redhat.com> <5267BAE7.2090300@redhat.com> <20131024111737.GC24862@khazad-dum.debian.net>
In-Reply-To: <20131024111737.GC24862@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/24/2013 07:17 AM, Henrique de Moraes Holschuh wrote:
> On Wed, 23 Oct 2013, Prarit Bhargava wrote:
>> After all this I completely forgot the problem I'm trying to solve here.  The
>> issue is that with HOTPLUG & request_microcode_nowait(), if the microcode image
>> is not found (that is the file is not found on disk), then EACH cpu waits 1
>> minute and it takes 2 hours for a 120 cpu box to load the microcode module.
> 
> The proper fix seems to be teaching the concept of negative caching to the
> microcode core/drivers, as it was pointed out elsewhere in the thread.
> Negative caching should have a lifetime of "the current update-all-cores
> request".
> 

Yes, I'm implementing v2 to do this already; caching the microcode is obvious.
I was actually looking at the code to see if there was a reason that each
processor needs to do a load request but cannot see one.  I'm modifying the
microcode driver to do this, as I said, in v2.

> This would fix the absurd compound timeout delays, as on most systems it
> will result in just one timeout (the first one).
> 
> That first timeout can be fixed by the user if they disable the userspace
> firmware loader helper.  IMHO that might well be the best choice, as it is
> already the way forward.

The problem with that is I may have a configuration which depends on having the
userspace firmware loader helper for a device, but not the processors so IMO it
isn't a complete solution.

I've also toyed with the idea that there should be a request_firmware_timeout()
in which a timeout for HOTPLUG can be specified.

P.
