Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbaBDTvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:51:54 -0500
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:30737
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932188AbaBDTvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:51:48 -0500
Message-ID: <52F144C3.1080705@caviumnetworks.com>
Date: Tue, 4 Feb 2014 11:51:31 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ralf Baechle <ralf@linux-mips.org>, <linux-arch@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: mips octeon memory model questions
References: <20140204184150.GB5002@laptop.programming.kicks-ass.net>
In-Reply-To: <20140204184150.GB5002@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-PRVS: 01128BA907
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(979002)(6009001)(199002)(53754006)(189002)(51704005)(24454002)(479174003)(377454003)(49866001)(47736001)(87936001)(77982001)(36756003)(76482001)(53806001)(76796001)(74876001)(80316001)(33656001)(59896001)(50466002)(92726001)(81686001)(56776001)(47776003)(74366001)(94946001)(79102001)(4396001)(50986001)(47976001)(76786001)(46102001)(83506001)(59766001)(77096001)(92566001)(74706001)(64126003)(83072002)(63696002)(81816001)(53416003)(54356001)(19580395003)(65956001)(31966008)(69226001)(74502001)(65806001)(80022001)(83322001)(56816005)(81342001)(80976001)(94316002)(51856001)(85852003)(23756003)(54316002)(85306002)(93516002)(66066001)(74662001)(47446002)(93136001)(90146001)(81542001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB178;H:BLUPRD0711HT005.namprd07.prod.outlook.com;CLIP:64.2.3.195;FPR:FC10F014.9EFAA3C1.7BC7AAA8.86F9F949.20348;InfoNoRecordsA:1;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 10:41 AM, Peter Zijlstra wrote:
> Hi all,
>
> I have a number of questions in regards to commit 6b07d38aaa520ce.
>
> Given that the octeon doesn't reorder reads; the following:
>
> "      sync
>         ll ...
>         .
>         .
>         .
>         sc ...
>         .
>         .
>         sync
>
>    The second SYNC was redundant, but harmless.  "
>
> Still doesn't make sense, because if we need the first sync to stop
> writes from being re-ordered with the ll-sc, we also need the second
> sync to avoid the same.
>
> Suppose:
>     STORE a
>     sync
>     LL-SC b
>     (not a sync)
>     STORE c
>
> What avoids this becoming visible as:
>
>    a
>    c
>    b

On OCTEON, SC implies a SYNC operation for the target memory location. 
So the "SC b" is ordered before any writes that come after the SC.


>
> ?
>
> Then there is:
>
> "       syncw;syncw
>          ll
>          .
>          .
>          .
>          sc
>          .
>          .
>
>      Has identical semantics to the first sequence, but is much faster.
>      The SYNCW orders the writes, and the SC will not complete successfully
>      until the write is committed to the coherent memory system.  So at the
>      end all preceeding writes have been committed.  Since Octeon does not
>      do speculative reads, this functions as a full barrier."
>
> Read Documentation/memory-barrier.txt:TRANSITIVITY, the above doesn't
> sound like syncw is actually multi-copy atomic, and therefore doesn't
> provide transitivity, and therefore is not a valid sequence for
> operations that are supposed to imply a full memory-barrier.
>
> Please as to explain.
>

It makes my head hurt.

The sequence:

    SYNCW
    LL a
    <other instructions that are not stores>
    SC a


Should function as a "<general barrier>".


I can try to explain why I think this is so:

Coherency is managed by the L2 Cache controller.

Each CPU has an n-entry write buffer.  The SYNCW insures that all 
preceding stores will commit before the store of the SC.  the 
instruction after the SC will not execute until the SC's store is committed.

The full SYNC instruction functions in a similar manner to the above 
sequence.  The only difference is that it doesn't have the side effect 
of modifying the target of the SC instruction.

In both cases all the stores are committed, and following loads are 
delayed until the commit is acknowledged.

Note:  All this is based on my understanding of the OCTEON 
micro-architecture.  I have not done any exhaustive testing Transitivity 
principle with respect to SYNCW/LL/SC as described above.

David Daney



