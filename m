Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab3GAOdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:33:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58577 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab3GAOdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:33:07 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130701102306.GC23515@pd.tnic>
References: <1372416851-56830-1-git-send-email-wedsonaf@gmail.com> <20130628111948.GA31065@gmail.com> <20130628140938.GA24819@pd.tnic> <CANeycqpiXO-B1+f-OXZfHaxxPd2aVEL0kutFp6-sALHqXNrazQ@mail.gmail.com> <20130630220004.GA23124@pd.tnic> <20130701075046.GB1681@gmail.com> <20130701102306.GC23515@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86: Use asm-goto to implement mutex fast path on x86-64
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 01 Jul 2013 07:30:14 -0700
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
CC: Wedson Almeida Filho <wedsonaf@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <19b76ce4-35e0-4f82-b7e9-aa07d5d8af2c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unconditional branches don't need prediction.  The branch predictor is used for conditional branches and in some hardware designs for indirect branches.  Unconditional direct branches never go through the branch predictor simply because the front end can know with 100% certainty where the flow of control will be.

Borislav Petkov <bp@alien8.de> wrote:

>On Mon, Jul 01, 2013 at 09:50:46AM +0200, Ingo Molnar wrote:
>> Not sure - the main thing we want to know is whether it gets faster.
>> The _amount_ will depend on things like precise usage patterns,
>> caching, etc. - but rarely does a real workload turn a win like this
>> into a loss.
>
>Yep, and it does get faster by a whopping 6 seconds!
>
>Almost all standard counters go down a bit.
>
>Interestingly, branch misses get a slight increase and the asm goto
>thing does actually jump to the fail_fn from within the asm so maybe
>this could puzzle the branch predictor a bit. Although the instructions
>look the same and jumps are both forward.
>
>Oh well, we don't know where those additional misses happened so it
>could be somewhere else entirely, or it is simply noise.
>
>In any case, we're getting faster, so not worth investigating I guess.
>
>
>plain 3.10
>==========
>
> Performance counter stats for '../build-kernel.sh' (5 runs):
>
>1312558.712266 task-clock                #    5.961 CPUs utilized      
>     ( +-  0.02% )
>1,036,629 context-switches          #    0.790 K/sec                   
>( +-  0.24% )
>55,118 cpu-migrations            #    0.042 K/sec                    (
>+-  0.25% )
>46,505,184 page-faults               #    0.035 M/sec                  
> ( +-  0.00% )
>4,768,420,289,997 cycles                    #    3.633 GHz             
>        ( +-  0.02% ) [83.79%]
>3,424,161,066,397 stalled-cycles-frontend   #   71.81% frontend cycles
>idle     ( +-  0.02% ) [83.78%]
>2,483,143,574,419 stalled-cycles-backend    #   52.07% backend  cycles
>idle     ( +-  0.04% ) [67.40%]
> 3,091,612,061,933 instructions              #    0.65  insns per cycle
>             #    1.11  stalled cycles per insn  ( +-  0.01% ) [83.93%]
>677,787,215,988 branches                  #  516.386 M/sec             
>      ( +-  0.01% ) [83.77%]
>25,438,736,368 branch-misses             #    3.75% of all branches    
>     ( +-  0.02% ) [83.78%]
>
>220.191740778 seconds time elapsed                                     
>    ( +-  0.32% )
>
> + patch
>========
>
> Performance counter stats for '../build-kernel.sh' (5 runs):
>
>1309995.427337 task-clock                #    6.106 CPUs utilized      
>     ( +-  0.09% )
>1,033,446 context-switches          #    0.789 K/sec                   
>( +-  0.23% )
>55,228 cpu-migrations            #    0.042 K/sec                    (
>+-  0.28% )
>46,484,992 page-faults               #    0.035 M/sec                  
> ( +-  0.00% )
>4,759,631,961,013 cycles                    #    3.633 GHz             
>        ( +-  0.09% ) [83.78%]
>3,415,933,806,156 stalled-cycles-frontend   #   71.77% frontend cycles
>idle     ( +-  0.12% ) [83.78%]
>2,476,066,765,933 stalled-cycles-backend    #   52.02% backend  cycles
>idle     ( +-  0.10% ) [67.38%]
> 3,089,317,073,397 instructions              #    0.65  insns per cycle
>             #    1.11  stalled cycles per insn  ( +-  0.02% ) [83.95%]
>677,623,252,827 branches                  #  517.271 M/sec             
>      ( +-  0.01% ) [83.79%]
>25,444,376,740 branch-misses             #    3.75% of all branches    
>     ( +-  0.02% ) [83.79%]
>
>214.533868029 seconds time elapsed                                     
>    ( +-  0.36% )

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
