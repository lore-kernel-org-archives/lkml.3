Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123Ab3IYQ17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:27:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab3IYQ16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:27:58 -0400
Date: Wed, 25 Sep 2013 18:21:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Hurley <peter@hurleysoftware.com>
Cc: codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Karel Srot <ksrot@redhat.com>, Matt Newsome <mnewsome@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: v3.10 breaks T.tcflush (Was: tty: disassociate_ctty() sends the
	extra SIGCONT)
Message-ID: <20130925162125.GA18984@redhat.com>
References: <20130915155006.GA11913@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130915155006.GA11913@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, thanks for your explanations about tty_old_pgrp/etc,
I'll try to reply later. I need to read your email carefully.

FYI, LSB tests report another failure starting from 3.10.

See lsb-test-core/lts_vsx-pcts/tset/POSIX.os/devclass/tcflush/tcflush.c
attached below. test4() fails with

	SIGTTOU not received
	tcflush(TCIOFLUSH) action was performed
	when TOSTOP was set

I'll try to investigate, but let me repeat I know absolutely nothing
about drivers/tty/, termios, etc. Perhaps you can take a look? So far I
didn't even look into the attached code, I have no idea what it does.

Thanks,

Oleg.

-------------------------------------------------------------------------------
/*
*      SCCS:  @(#)  POSIX.os/devclass/tcflush/tcflush.c Rel 4.4.1	    (06/09/97)
*
*	UniSoft Ltd., London, England
*
* (C) Copyright 1991 X/Open Company Limited
*
* All rights reserved.  No part of this source code may be reproduced,
* stored in a retrieval system, or transmitted, in any form or by any
* means, electronic, mechanical, photocopying, recording or otherwise,
* except as stated in the end-user licence agreement, without the prior
* permission of the copyright owners.
*
* X/Open and the 'X' symbol are trademarks of X/Open Company Limited in
* the UK and other countries.
*/

#ifndef lint
#define MAIN
#ifdef	MAIN
static	char sccsid[] = "@(#)POSIX.os/devclass/tcflush - T.tcflush Rel 4.4.1 (06/09/97)";
char	*copyright[] = {
		"(C) Copyright 1991 X/Open Company Limited",
		"All Rights Reserved."
};
#endif	/* MAIN */
#endif	/* lint */

/***********************************************************************

NAME:		T.tcflush

PROJECT:	VSX (X/OPEN Validation Suite)

DESCRIPTION:
	Testset for the tcflush() system call.

METHODS:
ASSUMES:
CONDITIONAL COMPILE PARAMS:
SIDE EFFECTS:
RELATED DOCUMENTS:
SOURCE:

AUTHOR:		Geoff Clare, UniSoft Ltd.
DATE CREATED:	20 Jan 1989
MODIFICATIONS: J.A.Nave	29/06/90
			Check for XXX_prep() functions returning 1 to
			indicate GTI unsupported

		David Sawyer
		Tue Aug 07 12:05:21 BST 1990
		Added resilience code.

		Stuart Boutell, 20 May 1992
			SIGTTOUT test now performed with TOSTOP mode set
		and clear.

		Stuart Boutell, 21 May 1992
		Removed dependency on GTI for EBADF and ENOTTY tests

		Stuart Boutell, 3 June 1992
		Add non-controlling terminal tests.

		Geoff Clare, 9 June 1992
			Allow for systems with no terminal output queue.

		Geoff Clare, 9 June 1993
			Change tcflow() call to tcflush() in test 14.

		Geoff Clare, 10 Feb 1995
			Use do_fnoeio() instead of do_feio().

************************************************************************/

#include <std.h>
#include <stdio.h>
#include <sys/types.h>
#include <dbug.h>
#include <report.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <signal.h>
#include <termios.h>
#include <timeout.h>
#include <tet_api.h>
#include <sysdep.h>

#ifdef UNDEF_MACROS
#undef tcflush
#endif


#define NO_TESTS	14
#define WAITTIME	(5 * SPEEDFACTOR)
#define NAP		2
#define READ_TIME	20
#define MODEANY		(S_IRWXU|S_IRWXG|S_IRWXO)
#define NOK		002
#define E_DEL		004
#define E_SAFAIL	010
#define E_GOTSIG	020
#define PATH_OK		040

#define USE_TTY		0x1
#define USE_LOOP	0x0

#define BUFLEN		(sizeof(outbuf)-1)

extern	char	*errname();
extern	void	do_fnoeio();
extern	void	xx_all();

int	no_tests = NO_TESTS;

private void	test1();
private void	test2();
private void	test3();
private void	test4();
private void	do_test4();
private void	test5();
private void	test6();
private void	test7();
private void	test8();
private void	test9();
private	void	test10();
private	void	test11();
private	void	test12();
private	void	do_test12();
private	void	test13();
private	void	test14();
private void	ch_t4();
private void	ch_t5();
private void	ch_t6();
private	void	ch_t10();
private	void	ch_t12();
private	void	ch_t13();
private void	gch_t5();
private void	gch_t6();
private void	gch_t10();
private void	gch_t13();
private	void	t14rpt();
private	int	t14io();
private void	prepare_tests();
private void	clean_tests();
private void	twrap();
private int	set_tostop();
private	int	clear_tostop();

public	void	(*realfuncs[]) () = { test1, test2, test3, test4, test5,
				      test6, NULL, test8, NULL, 
				      test10, test11, test12, test13, test14,
				      NULL };
public	void	(*setfunc) () = prepare_tests;
public	void	(*clnfunc) () = clean_tests;
public	struct tet_testlist tet_testlist[] = {
	twrap, 1,
	twrap, 2,
	twrap, 3,
	twrap, 4,
	twrap, 5,
	twrap, 6,
	test7, 7,
	twrap, 8,
	test9, 9,
	twrap, 10,
	twrap, 11,
	twrap, 12,
	twrap, 13,
	twrap, 14,
	NULL, 0
};

private	int	unsupported = 0;
private char	*tfile =	"./tcflush-t";
private char	outbuf[] = "'Twas brillig, and the slithy toves\nDid gyre ...";
private	char	inbuf[512];
private	int	tty_fildes, loop_fildes;
private	struct termios tty_termios, loop_termios,
		*loop_termios_p = &loop_termios,
		*tty_termios_p = &tty_termios;
private int	input, output;		/* read() returns		*/
private	int	caught_sig = 0;
private int	tc_ret;
private int	testfail;
private	int	buffered;

private void
sig_catch(sig)
{
	caught_sig = sig;
}


private void
do_looptcflush()
{
	int	pathok = 0;

	DBUG_ENTER("do_tcflush");

	tc_ret = tcflush(loop_fildes, TCIOFLUSH);

	PATH_FUNC_RPT(0); /* cppair expects globok to be set */

	DBUG_VOID_RETURN;
}
private void
do_tcflush()
{
	int	pathok = 0;

	DBUG_ENTER("do_tcflush");

	tc_ret = tcflush(tty_fildes, TCIOFLUSH);

	PATH_FUNC_RPT(0); /* cppair expects globok to be set */

	DBUG_VOID_RETURN;
}

private void
twrap()
{
	/* wrapper to check if unsupported and call real test function */

	DBUG_ENTER("twrap");

	if (unsupported)
	{
		xx_rpt(UNSUPPORTED);
		in_rpt("VSX_TERMIOS_TTY/LOOP is set to \"unsup\"");
		DBUG_VOID_RETURN;
	}

	if (tet_thistest >= 1 && tet_thistest <= no_tests)
		(*realfuncs[tet_thistest-1])();

	DBUG_VOID_RETURN;
}

private void
prepare_tests()
{
	char *msg = NULL;
	char	*cp;
	int i;

	DBUG_ENTER("prepare_tests");

	cp = tet_getvar("VSX_TERMIOS_BUFFERED");
	if (cp == NULL || *cp == '\0')
	{
		xx_all(DELETION, "parameter VSX_TERMIOS_BUFFERED is not set");
		DBUG_VOID_RETURN;
	}
	else if (*cp == 'N' || *cp == 'n')
		buffered = 0;
	else
		buffered = 1;

	/* Open and initialize terminal file */

	switch (termios_prep (&tty_fildes, tty_termios_p,
					  &loop_fildes, loop_termios_p))
	{
	case 0:
		break;
	case 1:
		unsupported = 1;
		DBUG_VOID_RETURN;
		/*NOTREACHED*/
		break;
	default:
		if (alrm_flag > 0)
			msg = "open/initialise VSX_TERMIOS_TTY and VSX_TERMIOS_LOOP timed out";
		else
			msg = "could not open/initialise VSX_TERMIOS_TTY and VSX_TERMIOS_LOOP";
		for (i = 1; i <= 6; i++)
			(void) tet_delete(i, msg);
		(void) tet_delete(8, msg);
		DBUG_VOID_RETURN;
	}

	loop_termios_p->c_lflag &= ~ICANON;
	loop_termios_p->c_cc[VTIME] = READ_TIME;
	loop_termios_p->c_cc[VMIN] = 0;

	if (tcsetattr(loop_fildes, TCSANOW, loop_termios_p) == SYSERROR)
	{
		for (i = 1; i <= NO_TESTS; i++)
			(void) tet_delete(i, "tcsetattr(TCSANOW) failed on VSX_TERMIOS_LOOP in preparation");
		DBUG_VOID_RETURN;
	}

	tty_termios_p->c_lflag |= TOSTOP;
	tty_termios_p->c_iflag |= IXON;
	tty_termios_p->c_lflag &= ~ICANON;
	tty_termios_p->c_cc[VTIME] = READ_TIME;
	tty_termios_p->c_cc[VMIN] = 0;

	if (tcsetattr(tty_fildes, TCSANOW, tty_termios_p) == SYSERROR)
	{
		for (i = 1; i <= NO_TESTS; i++)
			(void) tet_delete(i, "tcsetattr(TCSANOW) failed on VSX_TERMIOS_TTY in preparation");
		DBUG_VOID_RETURN;
	}

	SET_TIMEOUT(WAITTIME)

	/* check if writes/reads are working */

	if (write(loop_fildes, outbuf, BUFLEN) != BUFLEN)
		msg = "write() to VSX_TERMIOS_LOOP failed in preparation";
	else if (write(tty_fildes, outbuf, BUFLEN) != BUFLEN)
		msg = "write() to VSX_TERMIOS_TTY failed in preparation";

	CLEAR_ALARM

	if (msg == NULL)
	{
		(void) sleep(NAP);

		SET_TIMEOUT(WAITTIME)

		if (read(loop_fildes, inbuf, sizeof(inbuf)) != BUFLEN)
			msg = "read() from VSX_TERMIOS_LOOP failed in preparation";
		else if (read(tty_fildes, inbuf, sizeof(inbuf)) != BUFLEN)
			msg = "read() from VSX_TERMIOS_TTY failed in preparation";

		CLEAR_ALARM
	}

	if (msg != NULL)
	{
		for (i = 1; i <= NO_TESTS; i++)
			(void) tet_delete(i, msg);
	}

	DBUG_VOID_RETURN;
}

private void
clean_tests()
{
	DBUG_ENTER("clean_tests");

	if (!unsupported) {
		(void) close(tty_fildes);
		(void) close(loop_fildes);
	}
	(void) unlink(tfile);

	DBUG_VOID_RETURN;
}

private int
tprep(canon, use_tty)
int canon;	/* true if ICANON should be turned on */
int use_tty;	/* true if tty_fildes is to be tested.
			false if loop_fildes is to be tested. */
{
	int 	fail = 0;
	int 	err;
	int	pathok = 0;

	DBUG_ENTER("tprep");

	if (canon) {
			if (use_tty)
				tty_termios_p->c_lflag |= ICANON;
			else
				loop_termios_p->c_lflag |= ICANON;
	} else{
			if (use_tty)
				tty_termios_p->c_lflag &= ~ICANON;
			else
				loop_termios_p->c_lflag &= ~ICANON;
	}
	
	if (tcsetattr( (use_tty?tty_fildes:loop_fildes), TCSANOW,
			( use_tty?tty_termios_p:loop_termios_p )) == SYSERROR)
	{
		err = errno;
		if (testfail++ == 0)
			xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) failed on VSX_TERMIOS_%s - errno %d (%s)",
			(use_tty?"TTY":"LOOP"), err, errname(err));
		DBUG_RETURN(-1);
	}
	else
		PATH_TRACE;

	SET_TIMEOUT(WAITTIME)

	if (buffered && tcflow( (use_tty?tty_fildes:loop_fildes), TCOOFF) == SYSERROR)
	{
		fail = 1;
		err = errno;
	}
	else if (write(loop_fildes, outbuf, BUFLEN) != BUFLEN)
		fail = 2;
	else if (write(tty_fildes, outbuf, BUFLEN) != BUFLEN)
		fail = 3;
	else
		PATH_TRACE;
	
	CLEAR_ALARM

	if (fail != 0)
	{
		if (testfail++ == 0)
			xx_rpt(DELETION);
		switch (fail)
		{
		case 1:
			in_rpt("tcflow(TCOOFF) failed on VSX_TERMIOS_%s - errno %d (%s)",
				(use_tty?"TTY":"LOOP"), err, errname(err));
			break;
		case 2:
			in_rpt("write() to VSX_TERMIOS_LOOP failed");
			break;
		case 3:
			in_rpt("write() to VSX_TERMIOS_TTY failed");
			break;
		}
		DBUG_RETURN(-1);
	}
	else
		PATH_TRACE;

	(void) sleep(NAP);

	PATH_FUNC_RPT(3);

	DBUG_RETURN(0);
}

private int
clear_tostop(use_tty) 
int use_tty;
{
	int	pathok = 0;

	DBUG_ENTER("clear_tostop");

	if (use_tty)
		tty_termios_p->c_lflag &= ~(TOSTOP);
	else
		loop_termios_p->c_lflag &= ~(TOSTOP);

	if (tcsetattr( (use_tty? tty_fildes : loop_fildes), TCSANOW,
		(use_tty? tty_termios_p : loop_termios_p) ) == SYSERROR)
	{
		DBUG_RETURN(0);
	} else
		PATH_TRACE;

	PATH_FUNC_RPT(1);

	DBUG_RETURN(1);
}

private int
set_tostop(use_tty)
int use_tty;
{
	int	pathok = 0;

	DBUG_ENTER("set_tostop");

	if (use_tty)
		tty_termios_p->c_lflag |= TOSTOP;
	else
		loop_termios_p->c_lflag |= TOSTOP;

	if (tcsetattr( (use_tty? tty_fildes : loop_fildes), TCSANOW,
		(use_tty? tty_termios_p : loop_termios_p) ) == SYSERROR)
	{
		DBUG_RETURN(0);
	} else
		PATH_TRACE;

	PATH_FUNC_RPT(1);

	DBUG_RETURN(1);
}


private int
tread(use_tty)
int use_tty;
{
	int 	ret, err;
	int	pathok = 0;

	DBUG_ENTER("tread");

	SET_TIMEOUT(WAITTIME)

	ret = tcflow( (use_tty ? tty_fildes : loop_fildes), TCOON);
	err = errno;

	/* TCION call deleted (see comments on TCIOFF in tprep()) */

	CLEAR_ALARM

	if (ret == SYSERROR)
	{
		if (testfail++ == 0)
			xx_rpt(DELETION);
		in_rpt("tcflow(TCOON) failed on VSX_TERMIOS_%s - errno %d (%s)",
			(use_tty ? "TTY" : "LOOP"), err, errname(err));
		DBUG_RETURN(-1);
	}
	else
		PATH_TRACE;

	(void) sleep(NAP);

	input = 0;

	SET_TIMEOUT(WAITTIME)

	output = read( (use_tty ? loop_fildes : tty_fildes), inbuf, sizeof(inbuf));
	if (output >= 0)
	{
		PATH_TRACE;
		while (read( (use_tty ? tty_fildes : loop_fildes), inbuf, 1) > 0)
			++input;
	}
	else
		PATH_TRACE;
	
	CLEAR_ALARM

	if (output < 0)
	{
		if (testfail++ == 0)
			xx_rpt(DELETION);
		in_rpt("read() from VSX_TERMIOS_%s failed",
			(use_tty ? "LOOP":"TTY"));
		DBUG_RETURN(-1);
	}
	else
		PATH_TRACE;

	PATH_FUNC_RPT(3);

	DBUG_RETURN(0);
}


private void
test1()
{
	int 	rval, err;
	int	pathok = 0;

	DBUG_ENTER("test1");

	testfail = 0;

	globok = 0;
	if (tprep(0, USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	globok = 0;
	if ( ! set_tostop(USE_TTY) ) {
		xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) to set TOSTOP failed on VSX_TERMIOS_TTY");
		DBUG_VOID_RETURN;
	} else
		PATH_FUNC_TRACE;


	SET_TIMEOUT(WAITTIME)

	rval = tcflush(tty_fildes, TCIFLUSH);
	err = errno;

	CLEAR_ALARM

	if (rval != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIFLUSH) returned %d, expected 0", rval);
		in_rpt("errno was set to %d (%s)", err, errname(err));
	}
	else
		PATH_TRACE;

	globok = 0;
	if (tread(USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	if (output < BUFLEN)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIFLUSH) discarded output (non-canonical mode)");
	}
	else
		PATH_TRACE;

	if (input != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIFLUSH) did not discard input (non-canonical mode)");
	}
	else
		PATH_TRACE;

	/* repeat for canonical mode */

	globok = 0;
	if (tprep(1, USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	SET_TIMEOUT(WAITTIME)

	rval = tcflush(tty_fildes, TCIFLUSH);
	err = errno;

	CLEAR_ALARM

	if (rval != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIFLUSH) returned %d, expected 0", rval);
		in_rpt("errno was set to %d (%s)", err, errname(err));
	}
	else
		PATH_TRACE;

	globok = 0;
	if (tread(USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	if (output < BUFLEN)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIFLUSH) discarded output (canonical mode)");
	}
	else
		PATH_TRACE;

	if (input != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIFLUSH) did not discard input (canonical mode)");
	}
	else
		PATH_TRACE;

	if (testfail == 0)
		PATH_XS_RPT(11);

	DBUG_VOID_RETURN;
}

private void
test2()
{
	int 	rval, err;
	int	pathok = 0;

	DBUG_ENTER("test2");

	testfail = 0;

	globok = 0;
	if (tprep(0, USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	globok = 0;
	if ( ! set_tostop(USE_TTY) ) {
		xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) to set TOSTOP failed on VSX_TERMIOS_TTY");
		DBUG_VOID_RETURN;
	} else
		PATH_FUNC_TRACE;

	SET_TIMEOUT(WAITTIME)

	rval = tcflush(tty_fildes, TCOFLUSH);
	err = errno;

	CLEAR_ALARM

	if (rval != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCOFLUSH) returned %d, expected 0", rval);
		in_rpt("errno was set to %d (%s)", err, errname(err));
	}
	else
		PATH_TRACE;

	globok = 0;
	if (tread(USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	if (input < BUFLEN)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCOFLUSH) discarded input");
	}
	else
		PATH_TRACE;

	if (buffered && output != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCOFLUSH) did not discard output");
	}
	else
		PATH_TRACE;

	if (testfail == 0)
		PATH_XS_RPT(6);

	DBUG_VOID_RETURN;
}

private void
test3()
{
	int 	rval, err;
	int	pathok = 0;

	DBUG_ENTER("test3");

	testfail = 0;

	globok = 0;
	if (tprep(0, USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	globok = 0;
	if ( ! set_tostop(USE_TTY) ) {
		xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) to set TOSTOP failed on VSX_TERMIOS_TTY");
		DBUG_VOID_RETURN;
	} else
		PATH_FUNC_TRACE;

	SET_TIMEOUT(WAITTIME)

	rval = tcflush(tty_fildes, TCIOFLUSH);
	err = errno;

	CLEAR_ALARM

	if (rval != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) returned %d, expected 0", rval);
		in_rpt("errno was set to %d (%s)", err, errname(err));
	}
	else
		PATH_TRACE;

	globok = 0;
	if (tread(USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	if (input != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) did not discard input (non-canonical mode)");
	}
	else
		PATH_TRACE;

	if (buffered && output != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) did not discard output (non-canonical mode)");
	}
	else
		PATH_TRACE;

	/* repeat for canonical mode */

	globok = 0;
	if (tprep(1, USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	SET_TIMEOUT(WAITTIME)

	rval = tcflush(tty_fildes, TCIOFLUSH);
	err = errno;

	CLEAR_ALARM

	if (rval != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) returned %d, expected 0", rval);
		in_rpt("errno was set to %d (%s)", err, errname(err));
	}
	else
		PATH_TRACE;

	globok = 0;
	if (tread(USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	if (input != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) did not discard input (canonical mode)");
	}
	else
		PATH_TRACE;

	if (buffered && output != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) did not discard output (canonical mode)");
	}
	else
		PATH_TRACE;

	if (testfail == 0)
		PATH_XS_RPT(11);

	DBUG_VOID_RETURN;
}

private void
test4()
{
	int	pathok = 0;

	DBUG_ENTER("test4");

	if (sysconf(_SC_JOB_CONTROL) == -1)
	{
		xx_rpt(UNSUPPORTED);
		in_rpt("_POSIX_JOB_CONTROL not defined");
		DBUG_VOID_RETURN;
	}
	else
		PATH_TRACE;

	globok = 0;
	if ( ! set_tostop(USE_TTY) ) {
		xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) to set TOSTOP failed on VSX_TERMIOS_TTY");
		DBUG_VOID_RETURN;
	} else
		PATH_FUNC_TRACE;

	testfail = 0;

	globok = 0;
	do_test4();
	PATH_FUNC_TRACE;

	if (testfail != 0) {
		in_rpt("when TOSTOP was set");
	} else {

		globok = 0;
		if ( ! clear_tostop(USE_TTY) ) {
			xx_rpt(DELETION);
			in_rpt("tcsetattr(TCSANOW) to clear TOSTOP failed on VSX_TERMIOS_TTY");
			DBUG_VOID_RETURN;
		} else
			PATH_FUNC_TRACE;

		globok = 0;
		do_test4();
		PATH_FUNC_TRACE;

		if (testfail != 0) {
			in_rpt("when TOSTOP was clear");
		} else
			PATH_TRACE;
	}


	if (testfail == 0) 
		PATH_XS_RPT(6);


	DBUG_VOID_RETURN;
}

private
void
do_test4()
{
	int pathok = 0;

	DBUG_ENTER("do_test4");

	globok = 0;
	if (tprep(0, USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	switch (cppair(ch_t4, NULLFN, WAITTIME, E_DEL|NOK|PATH_OK))
	{
	case E_DEL:
		DBUG_VOID_RETURN;
	case NOK:
		testfail++;	/* reported in child */
		break;
	case PATH_OK:
		PATH_TRACE;
	}

	globok = 0;
	if (tread(USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	if (input < BUFLEN || output < BUFLEN)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) action was performed");
	}
	else
		PATH_TRACE;

	globok=0;
	if (testfail == 0)
		PATH_FUNC_RPT(4);

	DBUG_VOID_RETURN;
}

private void
ch_t4()
{
	struct sigaction sig;
	int	pathok = 0;

	DBUG_ENTER("ch_t4");

	if (setpgid((pid_t)0, (pid_t)0) == SYSERROR)
	{
		xx_rpt(DELETION);
		in_rpt("setpgid(0, 0) failed");
		DBUG_EXIT(E_DEL);
	}
	else
		PATH_TRACE;

	sig.sa_handler = sig_catch;
	sig.sa_flags = 0;
	(void) sigemptyset(&sig.sa_mask);
	if (sigaction(SIGTTOU, &sig, NULLSA) == SYSERROR)
	{
		xx_rpt(DELETION);
		in_rpt("sigaction(SIGTTOU, ...) failed");
		DBUG_EXIT(E_DEL);
	}
	else
		PATH_TRACE;
	caught_sig = 0;

	SET_TIMEOUT(WAITTIME/2)

	(void) tcflush(tty_fildes, TCIOFLUSH);
	if (alrm_flag == 0)
		(void) pause();

	CLEAR_ALARM


	if (caught_sig != SIGTTOU)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("SIGTTOU not received");
	}
	else
		PATH_TRACE;

	if (testfail != 0)
		DBUG_EXIT(NOK);

	if (pathok == 3)
		DBUG_EXIT(PATH_OK);

	DBUG_VOID_RETURN;
}

private void
test5()
{
	int	pathok = 0;

	DBUG_ENTER("test5");

	if (sysconf(_SC_JOB_CONTROL) == -1)
	{
		xx_rpt(UNSUPPORTED);
		in_rpt("_POSIX_JOB_CONTROL not defined");
		DBUG_VOID_RETURN;
	}
	else
		PATH_TRACE;

	globok = 0;
	if ( ! set_tostop(USE_TTY) ) {
		xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) to set TOSTOP failed on VSX_TERMIOS_TTY");
		DBUG_VOID_RETURN;
	} else
		PATH_FUNC_TRACE;

	testfail = 0;

	globok = 0;
	if (tprep(0, USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	switch (cppair(ch_t5, NULLFN, 2 * WAITTIME, E_DEL|NOK|PATH_OK))
	{
	case E_DEL:
		DBUG_VOID_RETURN;
	case NOK:
		testfail++;	/* reported in child */
		break;
	case PATH_OK:
		PATH_TRACE;
	}

	globok = 0;
	if (tread(USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	if (input != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) did not discard input");
	}
	else
		PATH_TRACE;

	if (buffered && output != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) did not discard output");
	}
	else
		PATH_TRACE;

	if (testfail == 0)
		PATH_XS_RPT(7);

	DBUG_VOID_RETURN;
}

private void
ch_t5()
{
	int 	ret;
	sigset_t set;
	struct sigaction sig;
	int	pathok = 0;

	DBUG_ENTER("ch_t5");

	if (setpgid((pid_t)0, (pid_t)0) == SYSERROR)
	{
		xx_rpt(DELETION);
		in_rpt("setpgid(0, 0) failed");
		DBUG_EXIT(E_DEL);
	}
	else
		PATH_TRACE;

	sig.sa_handler = sig_catch;
	sig.sa_flags = 0;
	(void) sigemptyset(&sig.sa_mask);
	if (sigaction(SIGTTOU, &sig, NULLSA) == SYSERROR)
	{
		xx_rpt(DELETION);
		in_rpt("sigaction(SIGTTOU, ...) failed");
		DBUG_EXIT(E_DEL);
	}
	else
		PATH_TRACE;

	/* block SIGTTOU */

	(void) sigemptyset(&set);
	(void) sigaddset(&set, SIGTTOU);
	if (sigprocmask(SIG_BLOCK, &set, (sigset_t *)0) == SYSERROR)
	{
		xx_rpt(DELETION);
		in_rpt("sigprocmask(SIG_BLOCK, ...) failed");
		DBUG_EXIT(E_DEL);
	}
	else
		PATH_TRACE;

	globok = 0;
	ret = cppair(gch_t5, do_tcflush, WAITTIME, E_SAFAIL|E_GOTSIG);
	if (ret == E_SAFAIL)
	{
		if (testfail++ == 0)
			xx_rpt(DELETION);
		in_rpt("sigaction(SIGTTOU, ...) failed");
		DBUG_EXIT(E_DEL);
	}
	else if (ret == E_GOTSIG)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("SIGTTOU received by child of calling process");
	}
	else
		PATH_FUNC_TRACE;

	if (tc_ret != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) returned %d, expected 0", tc_ret);
	}
	else
		PATH_TRACE;

	/* Check if SIGTTOU is pending?  (shouldn't be) */

	if (testfail != 0)
		DBUG_EXIT(NOK);

	if (pathok ==  5)
		DBUG_EXIT(PATH_OK);

	DBUG_VOID_RETURN;
}

private void
gch_t5()
{
	struct sigaction sig;

	DBUG_ENTER("gch_t5");

	sig.sa_handler = sig_catch;
	sig.sa_flags = 0;
	(void) sigemptyset(&sig.sa_mask);
	if (sigaction(SIGTTOU, &sig, NULLSA) == SYSERROR)
		DBUG_EXIT(E_SAFAIL);

	caught_sig = 0;

	(void) sleep(WAITTIME/2);	/* pause for signal */

	if (caught_sig == SIGTTOU)
		DBUG_EXIT(E_GOTSIG);

	DBUG_VOID_RETURN;
}

private void
test6()
{
	int	pathok = 0;

	DBUG_ENTER("test6");

	if (sysconf(_SC_JOB_CONTROL) == -1)
	{
		xx_rpt(UNSUPPORTED);
		in_rpt("_POSIX_JOB_CONTROL not defined");
		DBUG_VOID_RETURN;
	}
	else
		PATH_TRACE;

	globok = 0;
	if ( ! set_tostop(USE_TTY) ) {
		xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) to set TOSTOP failed on VSX_TERMIOS_TTY");
		DBUG_VOID_RETURN;
	} else
		PATH_FUNC_TRACE;

	testfail = 0;

	globok = 0;
	if (tprep(0, USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	globok = 0;
	switch (cppair(ch_t6, NULLFN, 2 * WAITTIME, E_DEL|NOK|PATH_OK))
	{
	case E_DEL:
		DBUG_VOID_RETURN;
	case NOK:
		testfail++;	/* reported in child */
		break;
	case PATH_OK:
		PATH_TRACE;
	}

	globok = 0;
	if (tread(USE_TTY) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	if (input != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) did not discard input");
	}
	else
		PATH_TRACE;

	if (buffered && output != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) did not discard output");
	}
	else
		PATH_TRACE;

	if (testfail == 0)
		PATH_XS_RPT(7);

	DBUG_VOID_RETURN;
}

private void
ch_t6()
{
	int ret;
	struct sigaction sig;
	int	pathok = 0;

	DBUG_ENTER("ch_t6");

	if (setpgid((pid_t)0, (pid_t)0) == SYSERROR)
	{
		xx_rpt(DELETION);
		in_rpt("setpgid(0, 0) failed");
		DBUG_EXIT(E_DEL);
	}
	else
		PATH_TRACE;

	sig.sa_handler = SIG_IGN;
	sig.sa_flags = 0;
	(void) sigemptyset(&sig.sa_mask);
	if (sigaction(SIGTTOU, &sig, NULLSA) == SYSERROR)
	{
		xx_rpt(DELETION);
		in_rpt("sigaction(SIGTTOU, ...) failed");
		DBUG_EXIT(E_DEL);
	}
	else
		PATH_TRACE;

	globok = 0;
	ret = cppair(gch_t6, do_tcflush, WAITTIME, E_SAFAIL|E_GOTSIG);
	if (ret == E_SAFAIL)
	{
		if (testfail++ == 0)
			xx_rpt(DELETION);
		in_rpt("sigaction(SIGTTOU, ...) failed");
		DBUG_EXIT(E_DEL);
	}
	else if (ret == E_GOTSIG)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("SIGTTOU received by child of calling process");
	}
	else
		PATH_FUNC_TRACE;

	if (tc_ret != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) returned %d, expected 0", tc_ret);
	}
	else
		PATH_TRACE;

	if (testfail != 0)
		DBUG_EXIT(NOK);

	if (pathok == 4)
		DBUG_EXIT(PATH_OK);

	DBUG_VOID_RETURN;
}

private void
gch_t6()
{
	struct sigaction sig;

	DBUG_ENTER("gch_t6");

	sig.sa_handler = sig_catch;
	sig.sa_flags = 0;
	(void) sigemptyset(&sig.sa_mask);
	if (sigaction(SIGTTOU, &sig, NULLSA) == SYSERROR)
		DBUG_EXIT(E_SAFAIL);

	caught_sig = 0;

	(void) sleep(WAITTIME/2);	/* pause for signal */

	if (caught_sig == SIGTTOU)
		DBUG_EXIT(E_GOTSIG);

	DBUG_VOID_RETURN;
}

private void
test7()
{
	int 	rval, err;
	int	pathok = 0;

	DBUG_ENTER("test7");

	testfail = 0;

	if ((rval = tcflush(-1, TCIOFLUSH)) != -1)
	{
		xx_rpt(FAILURE);
		in_rpt("tcflush(-1, TCIOFLUSH) returned %d, expected -1", rval);
	}
	else if (errno != EBADF)
	{
		err = errno;
		xx_rpt(FAILURE);
		in_rpt("tcflush(-1, TCIOFLUSH) gave errno %d (%s), expected EBADF",
			err, errname(err));
	}
	else
	{
		PATH_TRACE;
		PATH_XS_RPT(1);
	}

	DBUG_VOID_RETURN;
}

private void
test8()
{
	int 	rval, err;
	int	pathok = 0;

	DBUG_ENTER("test8");

	testfail = 0;

	globok = 0;
	if ( ! set_tostop(USE_TTY) ) {
		xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) to set TOSTOP failed on VSX_TERMIOS_TTY");
		DBUG_VOID_RETURN;
	} else
		PATH_FUNC_TRACE;

	if ((rval = tcflush(tty_fildes, -1)) != -1)
	{
		xx_rpt(FAILURE);
		in_rpt("tcflush(tty_fildes, -1) returned %d, expected -1", rval);
	}
	else if (errno != EINVAL)
	{
		err = errno;
		xx_rpt(FAILURE);
		in_rpt("tcflush(tty_fildes, -1) gave errno %d (%s), expected EINVAL",
			err, errname(err));
	}
	else
	{
		PATH_TRACE;
		PATH_XS_RPT(2);
	}

	DBUG_VOID_RETURN;
}

private void
test9()
{
	int 	fd, rval, err;
	int	pathok = 0;

	DBUG_ENTER("test9");

	testfail = 0;

	fd = creat(tfile, MODEANY);
	if (fd == SYSERROR)
	{
		xx_rpt(DELETION);
		in_rpt("could not create file %s", tfile);
		DBUG_VOID_RETURN;
	}
	else
		PATH_TRACE;

	if ((rval = tcflush(fd, TCIOFLUSH)) != -1)
	{
		xx_rpt(FAILURE);
		in_rpt("tcflush(fd, TCIOFLUSH) returned %d, expected -1", rval);
		in_rpt("where fd was open to a plain file");
	}
	else if (errno != ENOTTY)
	{
		err = errno;
		xx_rpt(FAILURE);
		in_rpt("tcflush(fd, TCIOFLUSH) gave errno %d (%s), expected ENOTTY",
			err, errname(err));
		in_rpt("where fd was open to a plain file");
	}
	else
	{
		PATH_TRACE;
		PATH_XS_RPT(2);
	}

	(void) close(fd);
	(void) unlink(tfile);

	DBUG_VOID_RETURN;
}

private void
test10()
{
	int	pathok = 0;

	DBUG_ENTER("test10");

	if (sysconf(_SC_JOB_CONTROL) == -1)
	{
		xx_rpt(UNSUPPORTED);
		in_rpt("_POSIX_JOB_CONTROL not defined");
		DBUG_VOID_RETURN;
	}
	else
		PATH_TRACE;

	globok = 0;
	if ( ! set_tostop(USE_LOOP) ) {
		xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) to set TOSTOP failed on VSX_TERMIOS_LOOP");
		DBUG_VOID_RETURN;
	} else
		PATH_FUNC_TRACE;

	globok = 0;
	if ( ! set_tostop(USE_TTY) ) {
		xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) to set TOSTOP failed on VSX_TERMIOS_TTY");
		DBUG_VOID_RETURN;
	} else
		PATH_FUNC_TRACE;

	testfail = 0;

	globok = 0;
	if (tprep(0, USE_LOOP) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	globok = 0;
	switch (cppair(ch_t10, NULLFN, 2 * WAITTIME, E_DEL|NOK|PATH_OK))
	{
	case E_DEL:
		DBUG_VOID_RETURN;
	case NOK:
		testfail++;	/* reported in child */
		break;
	case PATH_OK:
		PATH_TRACE;
	}

	globok = 0;
	if (tread(USE_LOOP) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	if (input != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) did not discard input");
	}
	else
		PATH_TRACE;

	if (buffered && output != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) did not discard output");
	}
	else
		PATH_TRACE;

	if (testfail == 0)
		PATH_XS_RPT(8);

	DBUG_VOID_RETURN;
}

private void
ch_t10()
{
	int ret;
	struct sigaction sig;
	int	pathok = 0;

	DBUG_ENTER("ch_t10");

	if (setpgid((pid_t)0, (pid_t)0) == SYSERROR)
	{
		xx_rpt(DELETION);
		in_rpt("setpgid(0, 0) failed");
		DBUG_EXIT(E_DEL);
	}
	else
		PATH_TRACE;

	sig.sa_handler = SIG_IGN;
	sig.sa_flags = 0;
	(void) sigemptyset(&sig.sa_mask);
	if (sigaction(SIGTTOU, &sig, NULLSA) == SYSERROR)
	{
		xx_rpt(DELETION);
		in_rpt("sigaction(SIGTTOU, ...) failed");
		DBUG_EXIT(E_DEL);
	}
	else
		PATH_TRACE;

	globok = 0;
	ret = cppair(gch_t10, do_looptcflush, WAITTIME, E_SAFAIL|E_GOTSIG);
	if (ret == E_SAFAIL)
	{
		if (testfail++ == 0)
			xx_rpt(DELETION);
		in_rpt("sigaction(SIGTTOU, ...) failed");
		DBUG_EXIT(E_DEL);
	}
	else if (ret == E_GOTSIG)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("SIGTTOU received by child of calling process");
	}
	else
		PATH_FUNC_TRACE;

	if (tc_ret != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) returned %d, expected 0", tc_ret);
	}
	else
		PATH_TRACE;

	if (testfail != 0)
		DBUG_EXIT(NOK);

	if (pathok == 4)
		DBUG_EXIT(PATH_OK);

	DBUG_VOID_RETURN;
}

private void
gch_t10()
{
	struct sigaction sig;

	DBUG_ENTER("gch_t10");

	sig.sa_handler = sig_catch;
	sig.sa_flags = 0;
	(void) sigemptyset(&sig.sa_mask);
	if (sigaction(SIGTTOU, &sig, NULLSA) == SYSERROR)
		DBUG_EXIT(E_SAFAIL);

	caught_sig = 0;

	(void) sleep(WAITTIME/2);	/* pause for signal */

	if (caught_sig == SIGTTOU)
		DBUG_EXIT(E_GOTSIG);

	DBUG_VOID_RETURN;
}

private void
test11()
{
	int 	rval, err;
	int	pathok = 0;

	DBUG_ENTER("test11");

	testfail = 0;

	globok = 0;
	if (tprep(0, USE_LOOP) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	globok = 0;
	if ( ! set_tostop(USE_LOOP) ) {
		xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) to set TOSTOP failed on VSX_TERMIOS_LOOP");
		DBUG_VOID_RETURN;
	} else
		PATH_FUNC_TRACE;

	globok = 0;
	if ( ! set_tostop(USE_TTY) ) {
		xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) to set TOSTOP failed on VSX_TERMIOS_TTY");
		DBUG_VOID_RETURN;
	} else
		PATH_FUNC_TRACE;

	SET_TIMEOUT(WAITTIME)

	rval = tcflush(loop_fildes, TCIFLUSH);
	err = errno;

	CLEAR_ALARM

	if (rval != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIFLUSH) returned %d, expected 0", rval);
		in_rpt("errno was set to %d (%s)", err, errname(err));
	}
	else
		PATH_TRACE;

	globok = 0;
	if (tread(USE_LOOP) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	if (output < BUFLEN)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIFLUSH) discarded output (non-canonical mode)");
	}
	else
		PATH_TRACE;

	if (input != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIFLUSH) did not discard input (non-canonical mode)");
	}
	else
		PATH_TRACE;

	/* repeat for canonical mode */

	globok = 0;
	if (tprep(1, USE_LOOP) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	SET_TIMEOUT(WAITTIME)

	rval = tcflush(loop_fildes, TCIFLUSH);
	err = errno;

	CLEAR_ALARM

	if (rval != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIFLUSH) returned %d, expected 0", rval);
		in_rpt("errno was set to %d (%s)", err, errname(err));
	}
	else
		PATH_TRACE;

	globok = 0;
	if (tread(USE_LOOP) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	if (output < BUFLEN)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIFLUSH) discarded output (canonical mode)");
	}
	else
		PATH_TRACE;

	if (input != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIFLUSH) did not discard input (canonical mode)");
	}
	else
		PATH_TRACE;

	if (testfail == 0)
		PATH_XS_RPT(12);

	DBUG_VOID_RETURN;
}

private void
test12()
{
	int	pathok = 0;

	DBUG_ENTER("test12");

	if (sysconf(_SC_JOB_CONTROL) == -1)
	{
		xx_rpt(UNSUPPORTED);
		in_rpt("_POSIX_JOB_CONTROL not defined");
		DBUG_VOID_RETURN;
	}
	else
		PATH_TRACE;

	globok = 0;
	if ( ! set_tostop(USE_LOOP) ) {
		xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) to set TOSTOP failed on VSX_TERMIOS_LOOP");
		DBUG_VOID_RETURN;
	} else
		PATH_FUNC_TRACE;

	globok = 0;
	if ( ! set_tostop(USE_TTY) ) {
		xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) to set TOSTOP failed on VSX_TERMIOS_TTY");
		DBUG_VOID_RETURN;
	} else
		PATH_FUNC_TRACE;

	testfail = 0;

	globok = 0;
	do_test12();
	PATH_FUNC_TRACE;

	if (testfail != 0) {
		in_rpt("when TOSTOP was set");
	} else {

		globok = 0;
		if ( ! clear_tostop(USE_LOOP) ) {
			xx_rpt(DELETION);
			in_rpt("tcsetattr(TCSANOW) to clear TOSTOP failed on VSX_TERMIOS_LOOP");
			DBUG_VOID_RETURN;
		} else
			PATH_FUNC_TRACE;

		globok = 0;
		if ( ! clear_tostop(USE_TTY) ) {
			xx_rpt(DELETION);
			in_rpt("tcsetattr(TCSANOW) to clear TOSTOP failed on VSX_TERMIOS_TTY");
			DBUG_VOID_RETURN;
		} else
			PATH_FUNC_TRACE;

		globok = 0;
		do_test12();
		PATH_FUNC_TRACE;

		if (testfail != 0) {
			in_rpt("when TOSTOP was clear");
		} else
			PATH_TRACE;
	}


	if (testfail == 0) 
		PATH_XS_RPT(8);


	DBUG_VOID_RETURN;
}

private
void
do_test12()
{
	int pathok = 0;

	DBUG_ENTER("do_test12");

	globok = 0;
	if (tprep(0, USE_LOOP) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	switch (cppair(ch_t12, NULLFN, WAITTIME, E_DEL|NOK|PATH_OK))
	{
	case E_DEL:
		DBUG_VOID_RETURN;
	case NOK:
		testfail++;	/* reported in child */
		break;
	case PATH_OK:
		PATH_TRACE;
	}

	globok = 0;
	if (tread(USE_LOOP) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	if (input != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) did not discard input");
	}
	else
		PATH_TRACE;

	if (buffered && output != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) did not discard output");
	}
	else
		PATH_TRACE;

	globok=0;
	if (testfail == 0)
		PATH_FUNC_RPT(5);

	DBUG_VOID_RETURN;
}

private void
ch_t12()
{
	struct sigaction sig;
	int	pathok = 0;

	DBUG_ENTER("ch_t12");

	if (setpgid((pid_t)0, (pid_t)0) == SYSERROR)
	{
		xx_rpt(DELETION);
		in_rpt("setpgid(0, 0) failed");
		DBUG_EXIT(E_DEL);
	}
	else
		PATH_TRACE;

	sig.sa_handler = sig_catch;
	sig.sa_flags = 0;
	(void) sigemptyset(&sig.sa_mask);
	if (sigaction(SIGTTOU, &sig, NULLSA) == SYSERROR)
	{
		xx_rpt(DELETION);
		in_rpt("sigaction(SIGTTOU, ...) failed");
		DBUG_EXIT(E_DEL);
	}
	else
		PATH_TRACE;
	caught_sig = 0;

	SET_TIMEOUT(WAITTIME/2)

	(void) tcflush(loop_fildes, TCIOFLUSH);
	if (alrm_flag == 0)
		(void) pause();

	CLEAR_ALARM


	if (caught_sig == SIGTTOU)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("SIGTTOU was received");
	}
	else
		PATH_TRACE;

	if (testfail != 0)
		DBUG_EXIT(NOK);

	if (pathok == 3)
		DBUG_EXIT(PATH_OK);

	DBUG_VOID_RETURN;
}

private void
test13()
{
	int	pathok = 0;

	DBUG_ENTER("test13");

	if (sysconf(_SC_JOB_CONTROL) == -1)
	{
		xx_rpt(UNSUPPORTED);
		in_rpt("_POSIX_JOB_CONTROL not defined");
		DBUG_VOID_RETURN;
	}
	else
		PATH_TRACE;

	globok = 0;
	if ( ! set_tostop(USE_LOOP) ) {
		xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) to set TOSTOP failed on VSX_TERMIOS_LOOP");
		DBUG_VOID_RETURN;
	} else
		PATH_FUNC_TRACE;

	globok = 0;
	if ( ! set_tostop(USE_TTY) ) {
		xx_rpt(DELETION);
		in_rpt("tcsetattr(TCSANOW) to set TOSTOP failed on VSX_TERMIOS_TTY");
		DBUG_VOID_RETURN;
	} else
		PATH_FUNC_TRACE;

	testfail = 0;

	globok = 0;
	if (tprep(0, USE_LOOP) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	switch (cppair(ch_t13, NULLFN, 2 * WAITTIME, E_DEL|NOK|PATH_OK))
	{
	case E_DEL:
		DBUG_VOID_RETURN;
	case NOK:
		testfail++;	/* reported in child */
		break;
	case PATH_OK:
		PATH_TRACE;
	}

	globok = 0;
	if (tread(USE_LOOP) != 0)
	{
		DBUG_VOID_RETURN;
	}
	else
		PATH_FUNC_TRACE;

	if (input != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) did not discard input");
	}
	else
		PATH_TRACE;

	if (buffered && output != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) did not discard output");
	}
	else
		PATH_TRACE;

	if (testfail == 0)
		PATH_XS_RPT(8);

	DBUG_VOID_RETURN;
}

private void
ch_t13()
{
	int 	ret;
	sigset_t set;
	struct sigaction sig;
	int	pathok = 0;

	DBUG_ENTER("ch_t13");

	if (setpgid((pid_t)0, (pid_t)0) == SYSERROR)
	{
		xx_rpt(DELETION);
		in_rpt("setpgid(0, 0) failed");
		DBUG_EXIT(E_DEL);
	}
	else
		PATH_TRACE;

	sig.sa_handler = sig_catch;
	sig.sa_flags = 0;
	(void) sigemptyset(&sig.sa_mask);
	if (sigaction(SIGTTOU, &sig, NULLSA) == SYSERROR)
	{
		xx_rpt(DELETION);
		in_rpt("sigaction(SIGTTOU, ...) failed");
		DBUG_EXIT(E_DEL);
	}
	else
		PATH_TRACE;

	/* block SIGTTOU */

	(void) sigemptyset(&set);
	(void) sigaddset(&set, SIGTTOU);
	if (sigprocmask(SIG_BLOCK, &set, (sigset_t *)0) == SYSERROR)
	{
		xx_rpt(DELETION);
		in_rpt("sigprocmask(SIG_BLOCK, ...) failed");
		DBUG_EXIT(E_DEL);
	}
	else
		PATH_TRACE;

	globok = 0;
	ret = cppair(gch_t13, do_looptcflush, WAITTIME, E_SAFAIL|E_GOTSIG);
	if (ret == E_SAFAIL)
	{
		if (testfail++ == 0)
			xx_rpt(DELETION);
		in_rpt("sigaction(SIGTTOU, ...) failed");
		DBUG_EXIT(E_DEL);
	}
	else if (ret == E_GOTSIG)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("SIGTTOU received by child of calling process");
	}
	else
		PATH_FUNC_TRACE;

	if (tc_ret != 0)
	{
		if (testfail++ == 0)
			xx_rpt(FAILURE);
		in_rpt("tcflush(TCIOFLUSH) returned %d, expected 0", tc_ret);
	}
	else
		PATH_TRACE;

	/* Check if SIGTTOU is pending?  (shouldn't be) */

	if (testfail != 0)
		DBUG_EXIT(NOK);

	if (pathok ==  5)
		DBUG_EXIT(PATH_OK);

	DBUG_VOID_RETURN;
}

private void
gch_t13()
{
	struct sigaction sig;

	DBUG_ENTER("gch_t13");

	sig.sa_handler = sig_catch;
	sig.sa_flags = 0;
	(void) sigemptyset(&sig.sa_mask);
	if (sigaction(SIGTTOU, &sig, NULLSA) == SYSERROR)
		DBUG_EXIT(E_SAFAIL);

	caught_sig = 0;

	(void) sleep(WAITTIME/2);	/* pause for signal */

	if (caught_sig == SIGTTOU)
		DBUG_EXIT(E_GOTSIG);

	DBUG_VOID_RETURN;
}


private void
test14()
{
	DBUG_ENTER("test14");

	do_fnoeio("w", -1,  t14io, t14rpt);

	DBUG_VOID_RETURN;
}

private int
t14io(fp)
FILE *fp;
{
	globok = 1;
	return tcflush(fileno(fp), TCOFLUSH);
}

private
void
t14rpt(ret, err)
int ret, err;
{
	int	pathok = 0;

	DBUG_ENTER("t14rpt");

	if(ret != 0)
	{
		xx_rpt(FAILURE);
		in_rpt("tcflush() from orphaned background process group did not give correct results");
		if (ret != 0)
			in_rpt("expected return: 0, actual: %d", ret);
		if (ret == SYSERROR)
			in_rpt("expected no error. actual errno: %d(%s)",
				err, errname(err));
	} else {
		PATH_TRACE;
		PATH_XS_RPT(1);
	}

	DBUG_VOID_RETURN;
}

