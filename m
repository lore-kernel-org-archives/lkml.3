Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3DYHYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 03:24:01 -0400
Received: from intranet.asianux.com ([58.214.24.6]:60718 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab3DYHX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 03:23:59 -0400
X-Spam-Score: -100.7
Message-ID: <5178D9DE.5010508@asianux.com>
Date: Thu, 25 Apr 2013 15:23:10 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
CC: Michael Neuling <mikey@neuling.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, sfr@canb.auug.org.au, matt@ozlabs.org,
        linux-kernel@vger.kernel.org, paulus@samba.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: "attempt to move .org backwards" still show up
References: <5177965D.9090406@linux.vnet.ibm.com> <20130424083142.GB26834@concordia> <51779941.8080403@linux.vnet.ibm.com> <30651.1366799858@ale.ozlabs.ibm.com> <1366807638.5911.2.camel@localhost> <5178816D.3000309@asianux.com> <5178ABA2.4030109@linux.vnet.ibm.com> <5178C0DE.9070503@asianux.com>
In-Reply-To: <5178C0DE.9070503@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月25日 13:36, Chen Gang wrote:
> On 2013年04月25日 12:05, Mike Qiu wrote:
>>> I will try, and plan to get a result within this week (2013-04-28)
>>>
>>> Thanks.
>> Hi
>> This has block my work now
>> So I hope you can take a look ASAP
>> Thanks
>> :)
> 
> The root cause is the room 0x500..0xc00 is not enough when
> KVM_HANDLER_PR expresses the real codes. The relationship is
> KVM_HANDLER_PR depend on CONFIG_KVM_BOOK3S_PR depend on
> CONFIG_KVM_BOOK3S_64_PR.
> 

Sorry, the original root cause above is incorrect.

The real root cause:
   __KVMTEST is used when CONFIG_KVM_BOOK3S_PR is defined.
   MASKABLE_EXCEPTION_PSERIES(0x900, 0x900, decrementer) includes __KVMTEST
     (it will start at 0x900 and just end at 0x980 !!)
   but STD_EXCEPTION_HV(0x980, 0x982, hdecrementer) is just started at 0x980 !

The relationship:
  dependency: __KVMTEST --> KVMTEST_PR --> CONFIG_KVM_BOOK3S_PR --> CONFIG_KVM_BOOK3S_64_PR
  using: MASKABLE_EXCEPTION_PSERIES --> SOFTEN_TEST_PR --> KVMTEST_PR --> __KVMTEST

Please reference below:
  0x93c..0x944 is just for __KVMTEST which will be inserted into when CONFIG_KVM_BOOK3S_PR is defined
  and the instructions of __KVMTEST are reordered for optimization.

0000000000000900 <decrementer_pSeries>:
     900:       7c 42 13 78     mr      r2,r2
     904:       7d b2 43 a6     mtsprg  2,r13
     908:       7d b1 42 a6     mfsprg  r13,1
     90c:       f9 2d 00 80     std     r9,128(r13)
     910:       7d 20 e2 a6     mfspr   r9,896
     914:       7c 42 13 78     mr      r2,r2
     918:       f9 4d 00 88     std     r10,136(r13)
     91c:       7d 5c 02 a6     mfspr   r10,28
     920:       f9 2d 00 d8     std     r9,216(r13)
     924:       f9 4d 00 d0     std     r10,208(r13)
     928:       7d 48 02 a6     mflr    r10
     92c:       f9 4d 00 c8     std     r10,200(r13)
     930:       7d 20 00 26     mfcr    r9
     934:       89 4d 07 c8     lbz     r10,1992(r13)
     938:       2c 0a 00 00     cmpwi   r10,0
     93c:       40 82 10 70     bne-    19ac <do_kvm_0x900>
     940:       89 4d 02 82     lbz     r10,642(r13)
     944:       2c 0a 00 00     cmpwi   r10,0
     948:       39 40 00 08     li      r10,8
     94c:       41 82 14 e4     beq-    1e30 <masked_interrupt>
     950:       f9 6d 00 90     std     r11,144(r13)
     954:       f9 8d 00 98     std     r12,152(r13)
     958:       7d 52 42 a6     mfsprg  r10,2
     95c:       f9 4d 00 a0     std     r10,160(r13)
     960:       e9 8d 00 18     ld      r12,24(r13)
     964:       e9 4d 00 20     ld      r10,32(r13)
     968:       7d 7a 02 a6     mfsrr0  r11
     96c:       61 8c 24 80     ori     r12,r12,9344
     970:       7d 9a 03 a6     mtsrr0  r12
     974:       7d 9b 02 a6     mfsrr1  r12
     978:       7d 5b 03 a6     mtsrr1  r10
     97c:       4c 00 00 24     rfid
     980:       48 00 00 00     b       980 <decrementer_pSeries+0x80>


> If possible, we can by pass it: just use CONFIG_KVM_BOOK3S_64_HV instead
> of CONFIG_KVM_BOOK3S_64_PR (enter menuconfig -> Virtualization -> "KVM
> support for POWER7 and PPC970 using hypervisor mode in host").
> 
> For 'allmodconfig', it will use CONFIG_KVM_BOOK3S_64_HV instead of
> CONFIG_KVM_BOOK3S_64_PR, so 'allmodconfig' will not have this issue.
> 
> 
> Next, I will continue to analyse how to fix it.
> 
> Welcome other members (especially the related maintainers) to provide
> suggestions and completions.
> 
> Thanks.
> 


-- 
Chen Gang

Asianux Corporation
