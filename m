Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3LCL77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:59:59 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:23199 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3LCL75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:59:57 -0500
X-IronPort-AV: E=Sophos;i="4.93,817,1378857600"; 
   d="scan'208";a="77680751"
Message-ID: <529DC7BA.7080506@citrix.com>
Date: Tue, 3 Dec 2013 11:59:54 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>	 <529DBA07.6090108@citrix.com> <1386068884.13256.9.camel@kazak.uk.xensource.com>
In-Reply-To: <1386068884.13256.9.camel@kazak.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/13 11:08, Ian Campbell wrote:
> On Tue, 2013-12-03 at 11:01 +0000, David Vrabel wrote:
>> On 03/12/13 10:57, Roger Pau Monne wrote:
>>> Using __packed__ on the public interface is not correct, this
>>> structures should be compiled using the native ABI, and __packed__
>>> should only be used in the backend counterpart of those structures
>>> (which needs to handle different ABIs).
>>>
>>> This was even worse in the ARM case, where the Linux kernel was
>>> incorrectly using the X86_32 protocol ABI. This patch fixes it, but
>>> also breaks compatibility, so an ARM DomU kernel compiled with
>>> this patch will fail to communicate with PV disk devices unless the
>>> Dom0 also has this patch.
>>
>> This ABI change needs to be justified.  Why do you think it is
>> acceptable to break existing Linux guests?  Because I don't think it is.
> 
> As I explained in my reply those guests are buggy.

The kernel has a strong policy on not changing ABIs, even to fix bugs.
I don't think a bug fix alone is sufficient justification for ABI breakage.

I think this change will cause real problems. e.g., if someone tries to
bisect a different guest problem across this change.

The commit message doesn't really give enough details on the problem so
please correct me if I'm misunderstanding.

1. The ARM ABI for blkif was specified as uniform between 32-bit and
64-bit and is equivalent to the x86_64 ABI.

2. ARM 32-bit back and frontend implementation did /not/ use this
defined ABI, but instead used the x86_32 ABI.  What did 32-bit ARM
frontends report as their ABI? x86_32? or native?

3. ARM 64-bit back and frontend implementation did use the specified
ABI, but the backend is not compatible with 32-bit ARM guests.  What did
64-bit ARM frontends report as their ABI?  x86_64? or native?

4. Support for 64-bit ARM guests is not upstream in Linux yet (so I
don't mind if 64-bit guests are broken).

I think this should be resolved in a backward compatible way.

1. Introduce a new blkif ABI that is uniform across all architectures
and 32-/64-bit. i.e., everything naturally aligned with explicit padding
fields as necessary.

2. Backend exports a 'feature-abi-v2' xenstore key if it supports this
new ABI.

3. Frontends uses the ABI and reports it, iff feature-abi-v2 is present.
Otherwise it must use the existing ABI. ARM 64-bit guests can require
this v2 ABI.

4. Backend may need an #if ARM assume x86_32 ABI if abi-v2 is not
reported by the frontend.

David
