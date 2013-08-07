Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab3HGTCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:02:08 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:34908 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab3HGTCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:02:06 -0400
Message-ID: <520299AB.1020607@linuxtoys.org>
Date: Wed, 07 Aug 2013 12:02:03 -0700
From: Bob Smith <bsmith@linuxtoys.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons
 a /sys-like interface
References: <51FC5478.40500@linuxtoys.org> <51FC5A97.1090102@linuxtoys.org> <20130803223828.GA14611@kroah.com> <51FECDA6.5070001@linuxtoys.org> <20130804231958.GA25418@kroah.com> <52003958.7080103@linuxtoys.org> <20130806094604.GE27889@kroah.com>
In-Reply-To: <20130806094604.GE27889@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg
    This sample program shows what I'm trying to accomplish.

I still owe you a reply for your previous posting

thanks
Bob Smith


/*
  * pxtest.c : This program demonstrates the use of a proxy device.
  *
  * The program generates some data once a second and tries to send
  * it to /dev/proxyout.  The original data is modified by adding
  * an offset to each input character.  The offset can be set or
  * viewed at the proxy device node /dev/proxyctrl.
  *
  * Typical usage might be
  *    sudo modprobe proxy
  *    PROXYDEV=`grep proxy /proc/devices | cut -d\  -f 1`
  *    sudo mknod /dev/proxyout c $PROXYDEV 0
  *    sudo mknod /dev/proxyctrl c $PROXYDEV 1
  *    sudo chmod 666 /dev/proxyout /dev/proxyctrl
  *    gcc -o pxtest pxtest.c
  *    ./pxtest &
  *    cat /dev/proxyout    # view the output
  *    (switch to another terminal window)
  *    cat /dev/proxyctrl   # what is the offset?
  *    echo 2 > /dev/proxyctrl  # set offset to 2
  */

#include <stdio.h>
#include <stdlib.h>
#include <termio.h>
#include <ctype.h>
#include <string.h>
#include <errno.h>
#include <sys/fcntl.h>
#include <sys/time.h>


extern int errno;
#define PXBUFZS 100


int main (int argc, char *argv[])
{
     fd_set rfds;                /* for select() */
     fd_set wfds;                /* for select() */
     int    nfds;                /* for select() */
     struct timeval tv;          /* for select() */
     time_t now;                 /* source of input data */
     int    i;
     int    offset = 0;          /* configured via /dev/proxyctrl */
     int    outfd;               /* fd to /dev/proxyout */
     char   obuff[PXBUFZS];
     int    listener;            /* ==1 if someone is listening at /dev/proxyout */
     int    ctrlfd = -1;         /* fd to /dev/proxyctrl */
     char   cbuff[PXBUFZS];      /* i/o buffer for /dev/proxyctrl */
     int    slret,wrret,rdret;   /* select() write() read() return value */


     outfd =  open("/dev/proxyout", (O_WRONLY | O_NDELAY) , 0);
     if (outfd < 0 ) {
         printf("Unable to open proxy output port\n");
         exit(1);
     }
     listener = 0;

     tv.tv_sec = 1;
     tv.tv_usec = 0;

     while(1) {
         FD_ZERO(&rfds);
         FD_ZERO(&wfds);

         /* open, or reopen, the offset control port at /dev/proxyctrl */
         if (ctrlfd == -1) {
             ctrlfd =  open("/dev/proxyctrl", O_RDWR | O_NDELAY,0);
             if (ctrlfd < 0 ) {
                 printf("Unable to open proxy control port\n");
                 exit(1);
             }
         }
         FD_SET(ctrlfd, &rfds);
         FD_SET(ctrlfd, &wfds);

         /* If no one is listening, watch for a connection */
         if (listener == 0) {
             FD_SET(outfd, &wfds);
         }

         nfds = (outfd > ctrlfd) ? outfd : ctrlfd;

         slret = select((nfds + 1), &rfds, &wfds, (fd_set *)NULL, &tv);

         if (slret == 0) {
             /* Generate bogus data.  Real data might be coming from
              * an I2C read or from an accelerometer at the end of a
              * USB serial link.  For now, just use the current time */
             time(&now);
             ctime_r(&now, obuff);

             /* "process" the data by adding offset to each character */
             i = 0;
             while (obuff[i] != '\n') {
                 obuff[i] = (char) (obuff[i] + offset);
                 obuff[i] = (isprint(obuff[i])) ? obuff[i] : '_';
                 i++;
             }

             /* Try to send the processed output to /dev/proxyout if possible */
             if (listener == 1) {
                 wrret = write(outfd, obuff, strlen(obuff));
                 if ((wrret == 0) || ((wrret < 0) && (errno == EAGAIN))) {
                     /* listener dropped off */
                     listener = 0;
                 }
             }
             tv.tv_sec = 1;
             tv.tv_usec = 0;
         }

         /* Did a listener attach at /dev/proxyout? */
         if (FD_ISSET(outfd, &wfds)) {
             listener = 1;
         }

         /* Data on /dev/proxyctrl is marshalled as newline terminated ASCII
          * This is not a requirement.  Use binary, XML or whatever you need.
          * This demo forces a close but that too is not required. */

         /* Did anyone ask to read the offset value? */
         if (FD_ISSET(ctrlfd, &wfds)) {
             snprintf(cbuff, PXBUFZS, "%d\n", offset);
             write(ctrlfd, cbuff, strlen(cbuff));  /* send offset value */
             write(ctrlfd, cbuff, 0);              /* send EOF */
         }

         /* Is anyone trying to set the offset value? */
         if (FD_ISSET(ctrlfd, &rfds)) {
             rdret = read(ctrlfd, cbuff, PXBUFZS);
             if (rdret == 0) {
                 close(ctrlfd);
                 ctrlfd = -1;
             } else if ((rdret > 0) && (cbuff[rdret - 1] == '\n')) {
                 /* buffer mgmt should be more than checking for ending \n */
                 sscanf(cbuff, "%d", &offset);
             }
         }
     }
}


