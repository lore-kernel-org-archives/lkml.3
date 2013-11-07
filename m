Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3KGBEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 20:04:00 -0500
Received: from hofr.at ([212.69.189.236]:33650 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab3KGBD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 20:03:59 -0500
Date: Thu, 7 Nov 2013 02:03:57 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
	/dev/random
Message-ID: <20131107010357.GC1950@opentech.at>
References: <2579337.FPgJGgHYdz@tauon> <4306229.ErfOL470s2@tauon> <20131106124354.GJ14235@thunk.org> <9172761.DO0L6FkY0c@tauon>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <9172761.DO0L6FkY0c@tauon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, 06 Nov 2013, Stephan Mueller wrote:

> Am Mittwoch, 6. November 2013, 07:43:54 schrieb Theodore Ts'o:
> 
> Hi Theodore,
> 
> >On Wed, Nov 06, 2013 at 12:49:45PM +0100, Stephan Mueller wrote:
> >> Here is a quote from his answer to my question whether he was able to
> >> identify the root cause:
> >> 
> >> "its inherent in the microtiming of Hardware and there is nothing you
> >> can do about it if you want the root cause is quantum physics"
> >
> >That's unfortunate, since it leaves open the question of whether this
> >jitter is something that could be at least somewhat predictable if you
> >had a lot more information about the internal works of the CPU or
> >not....
> 
> I do not understand that answer: I thought we are talking about the 
> search of non-predictable noise sources. If you cannot predict the 
> sequence even if you have the state of the CPU, that is what we are 
> looking for, is it not?

unpredictabilitty of the individual event does not imply that you do not have
the ability to "guess" with more than 50% - that is just because it is not 
predictable
does not mean itt is bias-free (and more importantly here that the bias is not 
influenced by controllable factors like load). Attached is a simple 
demonstration of this problem (gauss.c) that runs in user-space and harvestts 
entropy by race occurrence, while the distribution is a nice normal 
distribution (on multticore it is an overlay of multtiple normal 
distributions - one per core-pairing possible) it is not load independent. 
Never the less the individual event (race/no-race) is not predictable.

> 
> Besides, how on earth shall an attacker even gain knowledge about the 
> state of the CPU or disable CPU mechanisms? Oh, I forgot, your NSA guy. 
> But if he is able to do that, all discussions are moot because he simply 
> disables any noise sources by flipping a bit, reads the memory that is 
> used to hold the state of the RNG or just overwrites the memory 
> locations where data is collected, because the general protection 
> mechanisms offered by the kernel and the underlying hardware are broken.

No need to gain knowledge of the internal CPU state itt would be
sufficient to be able to put the CPU in a sub-state-space in which
the distribution is shifted. it may be enough to reduce the truely random
bits of some key only by a few bits to make it suceptible to brute force
attacks.

> 
> Also, does your answer mean you would disregard radioactive decay that 
> is not predictable due to quantum physics and Heisenberg?
>
maybe I missed something - but what does radioactive decay induced 
emission have to do with Heissenberg ? 

thx!
hofrat
 

--liOOAslEiF7prFVr
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="gauss.c"

/* gauss.c: 
 * A complicated way of producing normal distribution plots with a
 * modern CPU by harvesting the intherent randomness.
 *
 * This code is striped of almost all error checking and all argument
 * handling - this is intended to show the prinicple only.
 *
 * compile: gcc -O2 gause.c -o gause -lpthread
 * run: ./gause | tee logfile
 * 
 * be patient - this will take time if you want a smoth curve (hours..days !)
 * once you have a suitably long recording plot the distribution - brute force
 * might be 
 * sort -n logfile | uniq -c > data
 * gnuplot
 * ...
 * gnuplot> plot "data" using 2:1 with lines
 *
 * this will give you a nice gauss cure on all systems - if it does not then
 * your N needs adjusting !
 *
 * The only thing you must adjust to your hardware is N
 * here are some examples 32 bit:
 * AMD Duron UP         : 12000000
 * 32 bit install:
 * AMD Sempron UP       : 5000000
 * Core Duo E7400 SMP   : 100000
 * 64 bit intsll:
 * Intel Nehalem 8 core : 10000
 * Intel CoreDuo 2 Quad : 5000
 *
 * if the runs shows all samples close to 0 then increas N
 * if you get values all samples close to SAMPLES decrease N
 *
 * One could now speculate that this number actually is a metric for the
 * complexity of the CPU...
 *
 * further NUM_THREADS can be adjusted - in general 3 seems to be the best
 * though I have no clue why. Default 2 gives nice curves eventually as well.
 * if you fiddle with NUM_THREADS you also need to re-adjust N.
 *
 * what is this doing ? Its letting a set of threads race on a unprotected
 * global variable cnt - the run of the thread set is equivalent to drawing
 * a ball from an urn of infinetly many read and blue balls. If a race is
 * detected (cnt != N*NUM_THREADS) we assign this the color red, otherwise
 * blue.
 * The claim is that the occurance of red/blue is truely random and as evidence
 * this code produces close to perfect gause curves on and IDLE system. So this
 * is not driven by any peripheral interrupts or the like, in fact on high
 * loads things get a bit distorted... In my opinion this demonstrates that at
 * the core of a modern CPU there is in fact a true entropy source at work :)
 *
 * Copyright Der Herr Hofrat <der.herr@hofr.at> 2009,2010,2011
 * License GPL V2 or later (http://www.gnu.org/copyleft/gpl.html)
 *
 * If you use this code for anything useful I would be happy to here from you !
 *
 * thx!
 * hofrat
 */
#include <pthread.h>	/* pthread_* */
#include <stdio.h>      /* printf,perror,fflush */
#include <stdlib.h>     /* exit */

#define NUM_THREADS 2		/* number of concurrent threas */
volatile long cnt = 0;          /* the global object to race on */
unsigned long SAMPLES=256;	/* how many balls to draw from the urn */
unsigned long NUM_TRIALS=262144;	/* how many samples to draW */
unsigned long N=10000000;	/* some large number - depends on hardware */

void *Thread(void *);

/* This is the ESRNG that emits a ball
 * cnt describes the color of the ball
 */
void * Thread(void *v)
{
	unsigned long n;
	for (n = 1; n <= N; ++n) {
		++cnt;
	}
	return NULL;
}

/* draw the requested sampls from urn 
 * returns number of red balls 
 *
 * Note that return values of pthread_create/join
 * are checked as this would be critical if they failed
 * silent - all "unnecessary" error checking through was
 * removed.
 */
int draw_balls(int *samples){
	int i,n;
	unsigned long red;
	pthread_t t[NUM_THREADS];

	red=0;

	for(i=0;i<*samples;i++){
		cnt=0;

		/* sample the urn */
		for (n = 0; n < NUM_THREADS; ++n){
			if(pthread_create( t+n, NULL, Thread, NULL)){
 				perror("pthread_create");
				exit(-1);
			}
		}
		/* wait for the sample to complete */
		for (n = 0; n < NUM_THREADS; ++n){
			if(pthread_join(t[n],NULL)){
				perror("pthread_join");
				exit(-1);
			}
		}

		/* check the color 
		 * race occurs => red
 		 * no race     => blue
		 */
		if(N*NUM_THREADS - cnt){
		/* count the red */
			red++;
		}
	}
	return red;
}

/* simply get NUM_TRIALS sets of balls from 
 * the urn and print out how many were red 
 * and how many blue - plot this to get a 
 * nice gause curv.
 */
int main(int argc, char **argv)
{
	int i;
	int num_red,num_blue;
	int sample_size=SAMPLES;

	i=0;
	while(i++<NUM_TRIALS){
		num_red=draw_balls(&sample_size);
		num_blue=sample_size-num_red;
		printf("%d %d\n",num_red,num_blue);
		fflush(stdout);
	}
	return 0;
}

--liOOAslEiF7prFVr--
