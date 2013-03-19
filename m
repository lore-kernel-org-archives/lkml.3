Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089Ab3CSVAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:00:21 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:36186 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251Ab3CSVAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:00:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130316040132.15064.42257.stgit@localhost6.localdomain6>
Date: Tue, 19 Mar 2013 13:59:57 -0700
In-Reply-To: <20130316040132.15064.42257.stgit@localhost6.localdomain6>
	(HATAYAMA Daisuke's message of "Sat, 16 Mar 2013 13:01:32 +0900")
Message-ID: <878v5jqf5e.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18vmAS1UqB4Fzlv3RMKztIvUrK5ZPNQZng=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 08/21] vmcore: copy non page-size aligned head and tail pages in 2nd kernel
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:

> Due to mmap() requirement, we need to copy pages not starting or
> ending with page-size aligned address in 2nd kernel and to map them to
> user-space.
>
> For example, see the map below:
>
>     00000000-00010000 : reserved
>     00010000-0009f800 : System RAM
>     0009f800-000a0000 : reserved
>
> where the System RAM ends with 0x9f800 that is not page-size
> aligned. This map is divided into two parts:
>
>     00010000-0009f000
>     0009f000-0009f800
>
> and the first one is kept in old memory and the 2nd one is copied into
> buffer on 2nd kernel.
>
> This kind of non-page-size-aligned area can always occur since any
> part of System RAM can be converted into reserved area at runtime.
>
> If not doing copying like this and if remapping non page-size aligned
> pages on old memory directly, mmap() had to export memory which is not
> dump target to user-space. In the above example this is reserved
> 0x9f800-0xa0000.

So I have a question.  Would it not be easier to only support mmaping on
the things that are easily mmapable?  And in the oddball corner cases
require reading the data instead.

My gut feel says that would reduce the net complexity of the system a
bit, and would also reduce the amount of memory that the kernel has to
allocate.

Alrernatively and probably better given the nature of what is happening
here.  It seems entirely reasonable to round up the boundaries of the
supported mappings to the nearest page.  A little memory leak of data
in a reserved page should be harmless.

Eric
