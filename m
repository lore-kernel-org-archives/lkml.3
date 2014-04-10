Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031024AbaDJNmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:42:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030994AbaDJNmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:42:04 -0400
Message-ID: <53469F95.1030709@redhat.com>
Date: Thu, 10 Apr 2014 15:41:41 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
References: <20140406201628.GA507@redhat.com> <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com> <20140409154346.GB18486@redhat.com>
In-Reply-To: <20140409154346.GB18486@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 05:43 PM, Oleg Nesterov wrote:
> On 04/08, Jim Keniston wrote:
>>
>> On Sun, 2014-04-06 at 22:16 +0200, Oleg Nesterov wrote:
>>> 0xe8. Anything else?
>>
>> No, I think e8 is the only call instruction uprobes will see.
> 
> Good.

There is this monstrosity, "16-bit override for branches" in 64-mode:

66 e8 nn nn       callw   <offset16>

Nobody sane uses it because it truncates instruction pointer.

Or rather, *I think* it should truncate it (i.e. zero-extend to full width),
but conceivably some CPUs can be buggy wrt that:
they can decide to modify only lower 16 bits of IP,
or even they can decided to use signed <offset16> but apply it
to full-width RIP.

AMD manuals are not clear on what exactly should happen.

I am sure no one sane uses this form of branch instructions
in 32-bit and 64-bit code.

I don't think we should be trying to support it "correctly"
(we can just let program crash with SIGILL or something),
we only need to make sure we don't overlook its existence
and thus are not tricked into touching or modifying unrelated data.


Imagine that   66 e8 nn nn    bytes are exactly at the end of
a page, and we wrongly assume that offset is 32-bit, not 16-bit.

