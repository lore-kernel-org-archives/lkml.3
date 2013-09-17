Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab3IQUaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:30:55 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:60728 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753496Ab3IQUay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:30:54 -0400
Message-ID: <5238BBF3.5020504@hurleysoftware.com>
Date: Tue, 17 Sep 2013 16:30:43 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Carlos O'Donell" <carlos@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Karel Srot <ksrot@redhat.com>, Matt Newsome <mnewsome@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tty: disassociate_ctty() sends the extra SIGCONT
References: <20130915155006.GA11913@redhat.com> <20130915155026.GA11917@redhat.com> <52378345.50306@hurleysoftware.com> <5238B070.8060803@redhat.com>
In-Reply-To: <5238B070.8060803@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-Spam-Report: score=0.2 tests=ALL_TRUSTED, KHOP_BIG_TO_CC, TVD_RCVD_IP version=3.3.2
	cmae=v=2.1 cv=XLMJF2RE c=1 sm=0 tr=0 a=fi+bEUf2jW8nBMmSb+pBTg==:17
	a=HewVDi6x77QA:10 a=1DKwv_sK-1gA:10 a=lF0tP7JmhmIA:10 a=IkcTkHD0fZMA:10
	a=xGRsDScCAAAA:8 a=zFmFt3I4AAAA:8 a=IIQeXsxtAAAA:8 a=AYOluDIrMBwA:10
	a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=ag1SF4gXAAAA:8 a=_Q7YHMPmKkv4D5HbVDoA:9
	a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10
X-Spam-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 03:41 PM, Carlos O'Donell wrote:
> On 09/16/2013 06:16 PM, Peter Hurley wrote:
>> On 09/15/2013 11:50 AM, Oleg Nesterov wrote:
>>> Starting from v3.10 (probably f91e2590 "tty: Signal foreground
>>> group processes in hangup") disassociate_ctty() sends SIGCONT
>>> if tty && on_exit. This breaks LSB test-suite, in particular
>>> test8 in _exit.c and test40 in sigcon5.c.
>>>
>>> Put the "!on_exit" check back to restore the old behaviour.
>>>
>>> Cc: stable@vger.kernel.org # v3.10+
>>> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>>> Reported-by: Karel Srot <ksrot@redhat.com>
>>
>> Although I confirmed your results with a new unit test,
>> I'd like to review the source code for the reported tests.
>> Where can grab the source for the LSB tests, _exit.c and sigcon5.c?
>> Direct links would be appreciated.
>
> wget ftp://ftp.linuxfoundation.org/pub/lsb/test_suites/released-4.1/source/runtime/lsb-test-core-4.1.15-1.src.rpm
> rpm2cpio lsb-test-core-4.1.15-1.src.rpm | cpio -idmv
> tar zxvf lsb-test-core-4.1.15.tar.gz
> tar zxvf lts_vsx-pcts-4.1.15.tgz
>
> Source is at:
> ./tset/POSIX.os/procprim/_exit/_exit.c
> ./tset/POSIX.os/procprim/sigconcept/sigcon5.c

Hi Carlos,

Thanks for the links.

> In all failures the tests are checking for SIGHUP to be sent
> to a foreground process. It would appear that the additional
> signal confuses the test.
>
> Exactly what semantics should be followed do not seem to be
> clearly covered by any standards.
>
> Therefore it is likely just as valid to say that the LSB tests
> need to be more robust in the face of the additional signal.
>
> I have little experience when it comes this particular area
> of the kernel or expected behaviour from other OSs.

The _exit.c:test8() and sigcon5.c:test40() look correct to me.
The fact that they are fragile IMO is a good thing; I could
easily envision an app's signal handling being equally fragile.

Although SUSv3 & v4 don't preclude the extra SIGCONT, in this specific case,
a pty should receive the same signals, in the same order as a regular tty.

Thanks again,
Peter Hurley
