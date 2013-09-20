Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3ITFVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 01:21:00 -0400
Received: from nm19-vm10.access.bullet.mail.bf1.yahoo.com ([216.109.115.105]:28302
	"EHLO nm19-vm10.access.bullet.mail.bf1.yahoo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab3ITFU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 01:20:58 -0400
X-Yahoo-Newman-Id: 955841.38334.bm@smtp112.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: k81OxdUVM1mJryEmcSWLc5GNi3uravzhWlF7r7_D6YtPy8J
 m_1SsWfOYkv05zwIUuCXWOKc6ZxYSuAftfy00PEtZ2PFmNbGZa3BtOZwYjMo
 PHTxTj.KyAVtk5BtI3ALNYPVCuh1NNSX2juyriv6hDhHwfFAbhl01i3Ko3XR
 IMw_fp2rCIoRvlHRqr8i9fpzTA_jxgD27eVNTS_B8uf7y_WkM3yxJ64419xA
 UHBoo7ULiJ1r81tyaPvrHjHfMj5X8tOFvYSUq0dfqfw37vj2Xq.rHrjWNoOu
 nCsJHJx_eOigt7L.l.XYrG_CjVZVIk4jfbH2rBugoJASyUgnHw337qQt3R8B
 9zfs3BSUiXTMq4j.yiLrO0xy6zS7UvUhq1owIf4PXtg0c0x6xpdyVnnh86BM
 jk8BrPnXQgJdw3jvjvhWLjB9G_6IB5LJjk8n_64Wvk1_nIwUvBU30a1esMQ8
 on.8lOtbccM.yjcdxWAAaY0dnXoRpDYeso9v_Z8Gas.nAXrXK5MfTbxSvMv7
 ATNEK3Fnrei4EEaei7HodALuksl2hU7QzEJU-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with )
        by smtp112.sbc.mail.ne1.yahoo.com with SMTP; 19 Sep 2013 22:20:56 -0700 PDT
Message-ID: <523BDB55.2000008@att.net>
Date: Fri, 20 Sep 2013 00:21:25 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Daniel Santos <daniel.santos@pobox.com>,
        David Howells <dhowells@redhat.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 5/5] lib: Add error string support to printks
References: <1379482610.1787.7.camel@joe-AO722>  <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>  <1379459317-13046-6-git-send-email-daniel.santos@pobox.com>  <22238.1379502295@warthog.procyon.org.uk> <523A5316.50405@att.net> <1379639226.5862.9.camel@joe-AO722>
In-Reply-To: <1379639226.5862.9.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/19/2013 08:07 PM, Joe Perches wrote:
> On Wed, 2013-09-18 at 20:27 -0500, Daniel Santos wrote:
>> if I use ERR_PTR() on a signed int on a x86_64 where pointer
>> is 64 bits and int is 32, wouldn't that mean a signed conversion
>> instruction where the sign bit has to be moved from bit 31 to 63?
> No.  It's cast to long
>
> static inline void * __must_check ERR_PTR(long error)
> {
> 	return (void *) error;
> }

Yes, but it is that cast from int to long that costs us a signed extend 
instruction on platforms where sizeof(int) != sizeof(long).  This 
example should demonstrate the issue:

         extern void funca(void *ptr);

         static inline void * ERR_PTR(long error)
         {
                 return (void *) error;
         }

         void funcb(int i)
         {
                 funca(ERR_PTR(i));
         }

         void funcc(long l)
         {
                 funca(ERR_PTR(l));
         }

And here is the generated code on x86_64 with -O2:

         0000000000000000 <funcb>:
                 return (void *) error;
         }

         void funcb(int i)
         {
                 funca(ERR_PTR(i));
            0:   48 63 ff                movslq %edi,%rdi
            3:   e9 00 00 00 00          jmpq   8 <funcb+0x8>
                                 4: R_X86_64_PC32 funca-0x4
            8:   0f 1f 84 00 00 00 00    nopl 0x0(%rax,%rax,1)
            f:   00

         0000000000000010 <funcc>:
         }

         void funcc(long l)
         {
                 funca(ERR_PTR(l));
           10:   e9 00 00 00 00          jmpq   15 <funcc+0x5>
                                 11: R_X86_64_PC32 funca-0x4


So on x86_64 this movslq is 3 bytes of text, plus register pollution for 
each time you convert an int to a pointer. I don't know the precise 
number of cases where error numbers are passed to printk as ints, but I 
presume it is enough that this could add several kilobytes of text.  
Either way, for a popular function like vsnprintf, it's better to take a 
moderate bloat in the function than a little bloat at many call sites, 
especially when it's not performance critical.

>> Either way, %pE does seem to make a lot of sense for conditions where we
>> already have a pointer that we would otherwise use PTR_ERR() to convert,
>> but it just seems klunky to use it on an int, to have it treated like a
>> pointer and then re-interpreted as an int.  Maybe we can add %pE as well
>> as %dE and leave [ioxXu] out of it?
> I think having just one way to format is better.
>
Yeah, I do agree, I just don't see how to do it without introducing 
unnecessary bloat.

Daniel
