Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbaJGR6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:58:50 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:38231 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbaJGR6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:58:48 -0400
MIME-Version: 1.0
In-Reply-To: <543428E1.7050702@linux.vnet.ibm.com>
References: <trinity-2d36367c-59c5-44af-8737-fb503e10af38-1411376491498@3capp-gmx-bs07>
 <CALCETrWdPmSCUkb-neH5ssNmxzsqY0rioQq5qMc2ne7J0JxVLg@mail.gmail.com> <543428E1.7050702@linux.vnet.ibm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 7 Oct 2014 10:58:27 -0700
Message-ID: <CALCETrWoAkYTjetqm1e9zYGvetEhn0WQL5poLWv_saQktcHu7g@mail.gmail.com>
Subject: Re: [TrouSerS-tech] [Ksummit-discuss] TPM MiniSummit @ LinuxCon Europe
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Peter Huewe <PeterHuewe@gmx.de>, keyrings@linux-nfs.org,
        jarkko.sakkinnen@linux.intel.com,
        "ksummit-discuss@lists.linuxfoundation.org" 
	<ksummit-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        tpmdd-devel@lists.sourceforge.net,
        James Morris <james.l.morris@oracle.com>,
        linux-ima-devel@lists.sourceforge.net,
        trousers-tech@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 10:54 AM, Stefan Berger
<stefanb@linux.vnet.ibm.com> wrote:
> On 09/23/2014 12:42 PM, Andy Lutomirski wrote:
>>
>> On Sep 22, 2014 2:07 AM, "Peter Huewe" <PeterHuewe@gmx.de> wrote:
>>>
>>> Hi,
>>>
>>> I would like to 'invite' all interested parties in a short TPM minisummit
>>> where we can discuss the following hot topics of the TPM subsystem over a
>>> beer or two:
>>>   - State of the TPM Subsystem
>>>   - De-/Initialization Mess
>>>   - Devm'ification
>>>   - Testing
>>>   - TPM 2.0 Support
>>>   - Dependencies / interaction with other subsystems (e.g. keyring / IMA)
>>>   - Status of old 1.1b TPM drivers, deprecation plans
>>>   - ...
>>>
>> I am unlikely to be there, but I have a feature request / food for
>> thought:
>>
>> Using a mandatory userspace daemon (e.g. trousers) for TPM access
>> sucks.  Might it be possible to teach the kernel to handle context
>> save and restore and let multiple processes open the device at once?
>> Then a daemon wouldn't be necessary.
>
>
> Why add the complexity of swapping of authenticated sessions and keys into
> the kernel if you can handle this in userspace? You need a library that is
> aware of the number of key slots and slots for sessions in the TPM and swaps
> them in at out when applications need them. Trousers is such a library that
> was designed to cope with the limitations of the device and make its
> functionality available to all applications that want to access it.
>

Trousers is a daemon, not a library, and it's really quite scary.

Admittedly, my information may be a bit out of date, but trousers
contains way too much code (it has layers in the server!), it has
parsers and serializers of questionable safety (I found one critical
bug *by accident* a couple years ago), it listens on a TCP socket
(this should really be a UNIX socket under /run), it's heavy-weight,
and it does far more than necessary (all it needs to do is context
switching).

Also, Trousers is quite unfriendly to non-Trousers-using programs
(e.g. chapsd/trunks).

If the kernel helped with context switching, then user programs that
actually want Trousers' functionality could run their own copies.

--Andy
