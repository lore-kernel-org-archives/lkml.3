Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaJCOQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:16:54 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:44375 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaJCOQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:16:52 -0400
MIME-Version: 1.0
In-Reply-To: <1410910735-27929-3-git-send-email-maximilian@eschenbacher.email>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
	<1410910735-27929-3-git-send-email-maximilian@eschenbacher.email>
Date: Fri, 3 Oct 2014 17:16:51 +0300
Message-ID: <CABdoFFd6Qhonsjv8GYcPcxEftWdb8dxp3acwnhz5dUtfFQ5zsQ@mail.gmail.com>
Subject: Re: [PATCH 02/18] usbip: Add support for client authentication
From: Valentina Manea <valentina.manea.m@gmail.com>
To: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Cc: linux-kernel@vger.kernel.org, shuah.kh@samsung.com,
        Greg KH <gregkh@linuxfoundation.org>,
        Dominik Paulus <dominik.paulus@fau.de>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Is it only on my machines or there is a problem with the gnutls
3.3.0 headers? I get an error about offsetof being redefined, since
gnutls.h includes stddef.h, which defines this symbol as well, besides
libsrc/list.h. It works if I include the gnutls stuff after
usbip_host_driver.h in usbipd.c. Did a bit of debugging but I couldn't
pinpoint the cause of this.
* Same as Max said, this doesn't build with gnutls 2.12. I used 3.30
for building so you should add a check for the version in
configure.ac.
* As I can see, the password is "volatile" in server, ie. is lost
after the process ends. Along with what Max said, maybe I should be
stored in a file. On the server side, I suggest giving the user 2
options: either provide the password as you implemented, with a flag,
either get it from stdin and obfuscate the input.
* nit: on net_srp_server_handshake and net_srp_client_handshake, the
parameters are called differently even if the mean the same thing.
please choose either sockfd or connfd.
* Add gnutls as dependency and provide a short example of how to use
this feature in README.

Other than this, looks good. Thanks!

On Wed, Sep 17, 2014 at 2:38 AM, Maximilian Eschenbacher
<maximilian@eschenbacher.email> wrote:
> From: Dominik Paulus <dominik.paulus@fau.de>
>
> This patch adds support for authenticating both client and server using
> a pre-shared passphrase using SRP (Secure Remote Password) over TLS (see
> RFC 5054) using GnuTLS. Both usbip and usbipd now accept a shared secret
> as a command line argument. Currently, the established TLS connection is
> only used to perform a secure handshake and dropped before the socket is
> passed to the kernel. The code may be extended to exchange a session key
> over TLS and pass it to the kernel to perform IPsec.
>
> Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
> Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
> Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
> Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
> Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
> ---
>  tools/usb/usbip/configure.ac        |  14 +++
>  tools/usb/usbip/doc/usbip.8         |   4 +
>  tools/usb/usbip/doc/usbipd.8        |   5 +
>  tools/usb/usbip/src/usbip.c         |  30 +++++-
>  tools/usb/usbip/src/usbip_attach.c  |   2 +-
>  tools/usb/usbip/src/usbip_list.c    |   2 +-
>  tools/usb/usbip/src/usbip_network.c | 185 ++++++++++++++++++++++++++++++++++++
>  tools/usb/usbip/src/usbip_network.h |  11 ++-
>  tools/usb/usbip/src/usbipd.c        | 115 ++++++++++++++++------
>  9 files changed, 335 insertions(+), 33 deletions(-)
>
> diff --git a/tools/usb/usbip/configure.ac b/tools/usb/usbip/configure.ac
> index 607d05c..6a8156f 100644
> --- a/tools/usb/usbip/configure.ac
> +++ b/tools/usb/usbip/configure.ac
> @@ -83,6 +83,20 @@ AC_ARG_WITH([tcp-wrappers],
>                 AC_DEFINE([HAVE_LIBWRAP], [1], [use tcp wrapper])],
>                [AC_MSG_RESULT([no]); LIBS="$saved_LIBS"])])
>
> +# Checks for the GnuTLS library
> +AC_ARG_WITH([gnutls],
> +                       [AS_HELP_STRING([--with-gnutls],
> +                                                       [use the GnuTLS library for authentication])],
> +                       dnl [ACTION-IF-GIVEN]
> +                       [if test "$withval" = "yes"; then
> +                        PKG_CHECK_MODULES([GNUTLS], [gnutls])
> +                        AC_DEFINE([HAVE_GNUTLS], [1], [use gnutls])
> +                        CFLAGS="$CFLAGS $GNUTLS_CFLAGS"
> +                        LDFLAGS="$LDFLAGS $GNUTLS_LIBS"
> +                        fi
> +                       ],
> +                       )
> +
>  # Sets directory containing usb.ids.
>  AC_ARG_WITH([usbids-dir],
>             [AS_HELP_STRING([--with-usbids-dir=DIR],
> diff --git a/tools/usb/usbip/doc/usbip.8 b/tools/usb/usbip/doc/usbip.8
> index a6097be..847aa40 100644
> --- a/tools/usb/usbip/doc/usbip.8
> +++ b/tools/usb/usbip/doc/usbip.8
> @@ -27,6 +27,10 @@ Log to syslog.
>  \fB\-\-tcp-port PORT\fR
>  .IP
>  Connect to PORT on remote host (used for attach and list --remote).
> +
> +\fB\-\-auth\fR
> +.IP
> +Set the password to be used for client authentication. See usbipd(8) for more information.
>  .PP
>
>  .SH COMMANDS
> diff --git a/tools/usb/usbip/doc/usbipd.8 b/tools/usb/usbip/doc/usbipd.8
> index ac4635d..8beb95a 100644
> --- a/tools/usb/usbip/doc/usbipd.8
> +++ b/tools/usb/usbip/doc/usbipd.8
> @@ -52,6 +52,11 @@ If no FILE specified, use /var/run/usbipd.pid
>  \fB\-tPORT\fR, \fB\-\-tcp\-port PORT\fR
>  .IP
>  Listen on TCP/IP port PORT.
> +
> +.HP
> +\fB\-s\fR, \fB\-\-auth\fR
> +.IP
> +Sets the password to be used for client authentication. If -a is used, the server will only accept connections from authenticated clients. Note: USB traffic will still be unencrypted, this currently only serves for authentication.
>  .PP
>
>  \fB\-h\fR, \fB\-\-help\fR
> diff --git a/tools/usb/usbip/src/usbip.c b/tools/usb/usbip/src/usbip.c
> index d7599d9..cd7e420 100644
> --- a/tools/usb/usbip/src/usbip.c
> +++ b/tools/usb/usbip/src/usbip.c
> @@ -25,6 +25,12 @@
>  #include <getopt.h>
>  #include <syslog.h>
>
> +#include "../config.h"
> +
> +#ifdef HAVE_GNUTLS
> +#include <gnutls/gnutls.h>
> +#endif
> +
>  #include "usbip_common.h"
>  #include "usbip_network.h"
>  #include "usbip.h"
> @@ -35,8 +41,12 @@ static int usbip_version(int argc, char *argv[]);
>  static const char usbip_version_string[] = PACKAGE_STRING;
>
>  static const char usbip_usage_string[] =
> -       "usbip [--debug] [--log] [--tcp-port PORT] [version]\n"
> -       "             [help] <command> <args>\n";
> +       "usbip "
> +#ifdef HAVE_GNUTLS
> +       "[--auth PASSWORD] "
> +#endif
> +       "[--debug] [--log] [--tcp-port PORT]\n"
> +       "             [version] [help] <command> <args>\n";
>
>  static void usbip_usage(void)
>  {
> @@ -148,6 +158,7 @@ int main(int argc, char *argv[])
>                 { "debug",    no_argument,       NULL, 'd' },
>                 { "log",      no_argument,       NULL, 'l' },
>                 { "tcp-port", required_argument, NULL, 't' },
> +               { "auth",     required_argument, NULL, 's' },
>                 { NULL,       0,                 NULL,  0  }
>         };
>
> @@ -158,12 +169,25 @@ int main(int argc, char *argv[])
>         usbip_use_stderr = 1;
>         opterr = 0;
>         for (;;) {
> -               opt = getopt_long(argc, argv, "+dlt:", opts, NULL);
> +               opt = getopt_long(argc, argv, "+dls:t:", opts, NULL);
>
>                 if (opt == -1)
>                         break;
>
>                 switch (opt) {
> +               case 's':
> +#ifdef HAVE_GNUTLS
> +                       usbip_srp_password = optarg;
> +                       rc = gnutls_global_init();
> +                       if (rc < 0) {
> +                               err("Unable to initialize GnuTLS library: %s",
> +                                   gnutls_strerror(rc));
> +                               return EXIT_FAILURE;
> +                       }
> +#else
> +                       err("usbip has been compiled without GnuTLS support");
> +#endif
> +                       break;
>                 case 'd':
>                         usbip_use_debug = 1;
>                         break;
> diff --git a/tools/usb/usbip/src/usbip_attach.c b/tools/usb/usbip/src/usbip_attach.c
> index d58a14d..4421ebc 100644
> --- a/tools/usb/usbip/src/usbip_attach.c
> +++ b/tools/usb/usbip/src/usbip_attach.c
> @@ -175,7 +175,7 @@ static int attach_device(char *host, char *busid)
>         int rc;
>         int rhport;
>
> -       sockfd = usbip_net_tcp_connect(host, usbip_port_string);
> +       sockfd = usbip_net_connect(host);
>         if (sockfd < 0) {
>                 err("tcp connect");
>                 return -1;
> diff --git a/tools/usb/usbip/src/usbip_list.c b/tools/usb/usbip/src/usbip_list.c
> index d5ce34a..6042b7e 100644
> --- a/tools/usb/usbip/src/usbip_list.c
> +++ b/tools/usb/usbip/src/usbip_list.c
> @@ -132,7 +132,7 @@ static int list_exported_devices(char *host)
>         int rc;
>         int sockfd;
>
> -       sockfd = usbip_net_tcp_connect(host, usbip_port_string);
> +       sockfd = usbip_net_connect(host);
>         if (sockfd < 0) {
>                 err("could not connect to %s:%s: %s", host,
>                     usbip_port_string, gai_strerror(sockfd));
> diff --git a/tools/usb/usbip/src/usbip_network.c b/tools/usb/usbip/src/usbip_network.c
> index b4c37e7..6b8f949 100644
> --- a/tools/usb/usbip/src/usbip_network.c
> +++ b/tools/usb/usbip/src/usbip_network.c
> @@ -29,11 +29,20 @@
>  #include <tcpd.h>
>  #endif
>
> +#include "../config.h"
> +#ifdef HAVE_GNUTLS
> +#include <gnutls/gnutls.h>
> +#include <gnutls/crypto.h>
> +#endif
> +
>  #include "usbip_common.h"
>  #include "usbip_network.h"
>
>  int usbip_port = 3240;
>  char *usbip_port_string = "3240";
> +#ifdef HAVE_GNUTLS
> +char *usbip_srp_password;
> +#endif
>
>  void usbip_setup_port_number(char *arg)
>  {
> @@ -301,3 +310,179 @@ int usbip_net_tcp_connect(char *hostname, char *service)
>
>         return sockfd;
>  }
> +
> +#ifdef HAVE_GNUTLS
> +static gnutls_datum_t usbip_net_srp_salt, usbip_net_srp_verifier;
> +static gnutls_srp_server_credentials_t usbip_net_srp_cred;
> +
> +#define SRP_GROUP gnutls_srp_2048_group_generator
> +#define SRP_PRIME gnutls_srp_2048_group_prime
> +
> +int usbip_net_srp_client_handshake(int sockfd)
> +{
> +       int ret;
> +       gnutls_session_t session;
> +       gnutls_srp_client_credentials_t usbip_net_srp_cred;
> +
> +       ret = gnutls_srp_allocate_client_credentials(&usbip_net_srp_cred);
> +       if (ret < 0)
> +               return ret;
> +
> +       gnutls_srp_set_client_credentials(usbip_net_srp_cred, "dummyuser",
> +               usbip_srp_password);
> +
> +       ret = gnutls_init(&session, GNUTLS_CLIENT);
> +       if (ret < 0) {
> +               gnutls_srp_free_client_credentials(usbip_net_srp_cred);
> +               return ret;
> +       }
> +
> +       gnutls_priority_set_direct(session, "NORMAL:+SRP", NULL);
> +
> +       gnutls_credentials_set(session, GNUTLS_CRD_SRP, usbip_net_srp_cred);
> +       gnutls_transport_set_int (session, sockfd);
> +
> +       do {
> +               ret = gnutls_handshake(session);
> +       } while (ret < 0 && !gnutls_error_is_fatal(ret));
> +
> +       gnutls_bye(session, GNUTLS_SHUT_RDWR);
> +
> +       gnutls_deinit(session);
> +       gnutls_srp_free_client_credentials(usbip_net_srp_cred);
> +
> +       return ret;
> +}
> +
> +int net_srp_server_handshake(int connfd)
> +{
> +       int ret;
> +       gnutls_session_t session;
> +
> +       if (gnutls_init(&session, GNUTLS_SERVER) != 0)
> +               return -1;
> +       gnutls_priority_set_direct(session, "NORMAL:-KX-ALL:+SRP", NULL);
> +       ret = gnutls_credentials_set(session, GNUTLS_CRD_SRP,
> +                                    usbip_net_srp_cred);
> +       if (!ret)
> +               return -1;
> +
> +       gnutls_transport_set_int(session, connfd);
> +
> +       do {
> +               ret = gnutls_handshake(session);
> +       } while (ret < 0 && gnutls_error_is_fatal(ret) == 0);
> +
> +       if (ret < 0)
> +               err("GnuTLS handshake failed (%s)", gnutls_strerror(ret));
> +       else
> +               info("GnuTLS handshake completed");
> +
> +       if (gnutls_bye(session, GNUTLS_SHUT_RDWR) != 0)
> +               err("Unable to shutdown TLS connection.");
> +       gnutls_deinit(session);
> +
> +       return ret;
> +}
> +
> +static int net_srp_callback(gnutls_session_t sess, const char *username,
> +       gnutls_datum_t *nsalt, gnutls_datum_t *nverifier, gnutls_datum_t *g,
> +       gnutls_datum_t *n)
> +{
> +       /*
> +        * GnuTLS expects us to allocate all data returned from callbacks
> +        * using gnutls_malloc(), thus, we have to create a fresh copy of
> +        * our static credentials for every connection.
> +        */
> +       nsalt->data = gnutls_malloc(usbip_net_srp_salt.size);
> +       nverifier->data = gnutls_malloc(usbip_net_srp_verifier.size);
> +       if (nsalt->data == NULL || nverifier->data == NULL) {
> +               gnutls_free(nsalt->data);
> +               gnutls_free(nverifier->data);
> +               return -1;
> +       }
> +       nsalt->size = usbip_net_srp_salt.size;
> +       nverifier->size = usbip_net_srp_verifier.size;
> +       memcpy(nverifier->data, usbip_net_srp_verifier.data,
> +              usbip_net_srp_verifier.size);
> +       memcpy(nsalt->data, usbip_net_srp_salt.data, usbip_net_srp_salt.size);
> +
> +       *g = SRP_GROUP;
> +       *n = SRP_PRIME;
> +
> +       /* We only have a single session, thus, ignore it */
> +       (void) sess;
> +
> +       if (strcmp(username, "dummyuser"))
> +               /* User invalid, stored dummy data in g and n. */
> +               return 1;
> +
> +       return 0;
> +}
> +
> +int usbip_net_init_gnutls(void)
> +{
> +       int ret;
> +
> +       gnutls_global_init();
> +
> +       usbip_net_srp_salt.data = gnutls_malloc(16);
> +       if (!usbip_net_srp_salt.data)
> +               return GNUTLS_E_MEMORY_ERROR;
> +
> +       ret = gnutls_rnd(GNUTLS_RND_NONCE, usbip_net_srp_salt.data, 16);
> +       if (ret < 0)
> +               return ret;
> +       usbip_net_srp_salt.size = 16;
> +
> +       ret = gnutls_srp_allocate_server_credentials(&usbip_net_srp_cred);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret = gnutls_srp_verifier("dummyuser", optarg, &usbip_net_srp_salt,
> +                                 &SRP_GROUP, &SRP_PRIME,
> +                                 &usbip_net_srp_verifier);
> +       if (ret < 0)
> +               return ret;
> +
> +       gnutls_srp_set_server_credentials_function(usbip_net_srp_cred,
> +                                                  net_srp_callback);
> +
> +       return GNUTLS_E_SUCCESS;
> +}
> +#endif
> +
> +/*
> + * Connect to the server. Performs the TCP connection attempt
> + * and - if necessary - the TLS handshake used for authentication.
> + */
> +int usbip_net_connect(char *hostname)
> +{
> +       int sockfd;
> +
> +       sockfd = usbip_net_tcp_connect(hostname, usbip_port_string);
> +       if (sockfd < 0)
> +               return sockfd;
> +
> +#ifdef HAVE_GNUTLS
> +       if (usbip_srp_password) {
> +               int rc;
> +
> +               rc = usbip_net_send_op_common(sockfd, OP_REQ_STARTTLS, 0);
> +               if (rc < 0) {
> +                       err("usbip_net_send_op_common failed");
> +                       return EAI_SYSTEM;
> +               }
> +
> +               rc = usbip_net_srp_client_handshake(sockfd);
> +               if (rc < 0) {
> +                       err("Unable to perform TLS handshake (wrong password?): %s",
> +                           gnutls_strerror(rc));
> +                       close(sockfd);
> +                       return EAI_SYSTEM;
> +               }
> +       }
> +#endif
> +
> +       return sockfd;
> +}
> diff --git a/tools/usb/usbip/src/usbip_network.h b/tools/usb/usbip/src/usbip_network.h
> index c1e875c..292d584 100644
> --- a/tools/usb/usbip/src/usbip_network.h
> +++ b/tools/usb/usbip/src/usbip_network.h
> @@ -15,6 +15,7 @@
>
>  extern int usbip_port;
>  extern char *usbip_port_string;
> +extern char *usbip_srp_password;
>  void usbip_setup_port_number(char *arg);
>
>  /* ---------------------------------------------------------------------- */
> @@ -167,6 +168,12 @@ struct op_devlist_reply_extra {
>         usbip_net_pack_uint32_t(pack, &(reply)->ndev);\
>  } while (0)
>
> +/* ---------------------------------------------------------------------- */
> +/* Initiate encrypted connection. */
> +#define OP_STARTTLS 0x06
> +#define OP_REQ_STARTTLS   (OP_REQUEST | OP_STARTTLS)
> +#define OP_REP_STARTTLS   (OP_REPLY   | OP_STARTTLS)
> +
>  void usbip_net_pack_uint32_t(int pack, uint32_t *num);
>  void usbip_net_pack_uint16_t(int pack, uint16_t *num);
>  void usbip_net_pack_usb_device(int pack, struct usbip_usb_device *udev);
> @@ -180,6 +187,8 @@ int usbip_net_set_reuseaddr(int sockfd);
>  int usbip_net_set_nodelay(int sockfd);
>  int usbip_net_set_keepalive(int sockfd);
>  int usbip_net_set_v6only(int sockfd);
> -int usbip_net_tcp_connect(char *hostname, char *port);
> +int usbip_net_connect(char *hostname);
> +int net_srp_server_handshake(int connfd);
> +int usbip_net_init_gnutls(void);
>
>  #endif /* __USBIP_NETWORK_H */
> diff --git a/tools/usb/usbip/src/usbipd.c b/tools/usb/usbip/src/usbipd.c
> index 2f87f2d..23c15d7 100644
> --- a/tools/usb/usbip/src/usbipd.c
> +++ b/tools/usb/usbip/src/usbipd.c
> @@ -36,6 +36,11 @@
>  #include <tcpd.h>
>  #endif
>
> +#ifdef HAVE_GNUTLS
> +#include <gnutls/gnutls.h>
> +#include <gnutls/crypto.h>
> +#endif
> +
>  #include <getopt.h>
>  #include <signal.h>
>  #include <poll.h>
> @@ -64,6 +69,11 @@ static const char usbipd_help_string[] =
>         "       -6, --ipv6\n"
>         "               Bind to IPv6. Default is both.\n"
>         "\n"
> +#ifdef HAVE_GNUTLS
> +       "       -sPASSWORD, --auth PASSWORD\n"
> +       "               Set PASSWORD as key used for authentication.\n"
> +       "\n"
> +#endif
>         "       -D, --daemon\n"
>         "               Run as a daemon process.\n"
>         "\n"
> @@ -83,6 +93,8 @@ static const char usbipd_help_string[] =
>         "       -v, --version\n"
>         "               Show version.\n";
>
> +static int need_auth;
> +
>  static void usbipd_help(void)
>  {
>         printf("%s\n", usbipd_help_string);
> @@ -239,14 +251,7 @@ static int recv_request_devlist(int connfd)
>
>  static int recv_pdu(int connfd)
>  {
> -       uint16_t code = OP_UNSPEC;
> -       int ret;
> -
> -       ret = usbip_net_recv_op_common(connfd, &code);
> -       if (ret < 0) {
> -               dbg("could not receive opcode: %#0x", code);
> -               return -1;
> -       }
> +       int auth = !need_auth, cont = 1, ret;
>
>         ret = usbip_host_refresh_device_list();
>         if (ret < 0) {
> @@ -254,25 +259,63 @@ static int recv_pdu(int connfd)
>                 return -1;
>         }
>
> -       info("received request: %#0x(%d)", code, connfd);
> -       switch (code) {
> -       case OP_REQ_DEVLIST:
> -               ret = recv_request_devlist(connfd);
> -               break;
> -       case OP_REQ_IMPORT:
> -               ret = recv_request_import(connfd);
> -               break;
> -       case OP_REQ_DEVINFO:
> -       case OP_REQ_CRYPKEY:
> -       default:
> -               err("received an unknown opcode: %#0x", code);
> -               ret = -1;
> -       }
> +       /*
> +        * Process opcodes. We might receive more than one, as the
> +        * client might send STARTTLS first
> +        */
> +       while (cont) {
> +               uint16_t code = OP_UNSPEC;
>
> -       if (ret == 0)
> -               info("request %#0x(%d): complete", code, connfd);
> -       else
> -               info("request %#0x(%d): failed", code, connfd);
> +               ret = usbip_net_recv_op_common(connfd, &code);
> +               if (ret < 0) {
> +                       dbg("could not receive opcode: %#0x", code);
> +                       return -1;
> +               }
> +
> +               info("received request: %#0x(%d)", code, connfd);
> +
> +               /* We require an authenticated encryption */
> +               if (!auth && code != OP_REQ_STARTTLS) {
> +                       usbip_net_send_op_common(connfd, OP_REPLY, ST_NA);
> +                       return -1;
> +               }
> +
> +               switch (code) {
> +#ifdef HAVE_GNUTLS
> +               case OP_REQ_STARTTLS:
> +                       if (!need_auth) {
> +                               ret = -1;
> +                               err("Unexpected TLS handshake attempt (client uses password, server doesn't)");
> +                       } else {
> +                               ret = net_srp_server_handshake(connfd);
> +                               if (ret != 0)
> +                                       err("TLS handshake failed");
> +                               auth = 1;
> +                       }
> +                       break;
> +#endif
> +               case OP_REQ_DEVLIST:
> +                       ret = recv_request_devlist(connfd);
> +                       cont = 0;
> +                       break;
> +               case OP_REQ_IMPORT:
> +                       ret = recv_request_import(connfd);
> +                       cont = 0;
> +                       break;
> +               case OP_REQ_DEVINFO:
> +               case OP_REQ_CRYPKEY:
> +               default:
> +                       err("received an unknown opcode: %#0x", code);
> +                       ret = -1;
> +               }
> +
> +               if (ret == 0)
> +                       info("request %#0x(%d): complete", code, connfd);
> +               else {
> +                       info("request %#0x(%d): failed", code, connfd);
> +                       break;
> +               }
> +       }
>
>         return ret;
>  }
> @@ -593,6 +636,7 @@ int main(int argc, char *argv[])
>                 { "tcp-port", required_argument, NULL, 't' },
>                 { "help",     no_argument,       NULL, 'h' },
>                 { "version",  no_argument,       NULL, 'v' },
> +               { "auth",     required_argument, NULL, 's' },
>                 { NULL,       0,                 NULL,  0  }
>         };
>
> @@ -605,6 +649,9 @@ int main(int argc, char *argv[])
>         int daemonize = 0;
>         int ipv4 = 0, ipv6 = 0;
>         int opt, rc = -1;
> +#ifdef HAVE_GNUTLS
> +       int ret;
> +#endif
>
>         pid_file = NULL;
>
> @@ -616,7 +663,7 @@ int main(int argc, char *argv[])
>
>         cmd = cmd_standalone_mode;
>         for (;;) {
> -               opt = getopt_long(argc, argv, "46DdP::t:hv", longopts, NULL);
> +               opt = getopt_long(argc, argv, "46s:DdP::t:hv", longopts, NULL);
>
>                 if (opt == -1)
>                         break;
> @@ -628,6 +675,20 @@ int main(int argc, char *argv[])
>                 case '6':
>                         ipv6 = 1;
>                         break;
> +               case 's':
> +#ifdef HAVE_GNUTLS
> +                       need_auth = 1;
> +                       ret = usbip_net_init_gnutls();
> +                       if (ret < 0) {
> +                               err("Unable to initialize GnuTLS: %s",
> +                                   gnutls_strerror(ret));
> +                               return EXIT_FAILURE;
> +                       }
> +                       break;
> +#else
> +                       err("usbipd has been compiled without GnuTLS support");
> +                       break;
> +#endif
>                 case 'D':
>                         daemonize = 1;
>                         break;
> --
> 2.1.0
>
